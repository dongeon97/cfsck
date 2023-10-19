/*
 * dclist.c -- delay check list functions
 *
 */

#include "config.h"
#include <stdio.h>
#if HAVE_UNISTD_H
#include <unistd.h>
#endif
#include <string.h>
#include <time.h>

#include "ext2_fs.h"
#include "ext2fsP.h"

/*
 * helper function for making a new delay check list (for
 * initialize and copy).
 */
static errcode_t make_dclist(ext2_filsys fs, ext2_ino_t size,
			     ext2_ino_t count,
			     struct ext2_dc_entry *list,
			     ext2_dclist *ret_dclist)
{
	ext2_dclist	dclist = NULL;
	errcode_t	retval;
	ext2_ino_t	num_dirs;
	size_t		len;

	if ((ret_dclist == 0) && (fs && fs->dclist))
		return 0;

	retval = ext2fs_get_mem(sizeof(struct ext2_struct_dclist), &dclist);
	if (retval)
		goto cleanup;
	memset(dclist, 0, sizeof(struct ext2_struct_dclist));

	dclist->fs = fs;
	if (size)
		dclist->size = size;
	else {
		dclist->size = 100; // Can be changed !
	}
	len = (size_t) sizeof(struct ext2_dc_entry) * dclist->size;
	dclist->count = count;
	retval = ext2fs_get_array(dclist->size, sizeof(struct ext2_dc_entry),
		&dclist->list);
	if (retval)
		goto cleanup;

	if (list)
		memcpy(dclist->list, list, len);
	else
		memset(dclist->list, 0, len);
	if (ret_dclist)
		*ret_dclist = dclist;
	else{
        if(fs)
		    fs->dclist = dclist;
    }
	return 0;
cleanup:
	if (dclist)
		ext2fs_free_mem(&dclist);
	return retval;
}

/*
 * Initialize a delay check list
 */
errcode_t ext2fs_init_dclist(ext2_filsys fs, ext2_dclist *ret_dclist)
{
	ext2_dclist	dclist;
	errcode_t	retval;

	retval = make_dclist(fs, 0, 0, 0, &dclist);
	if (retval)
		return retval;

	if (ret_dclist)
		*ret_dclist = dclist;
	else{
        if(fs)
		    fs->dclist = dclist;
    }
	return 0;
}

/*
 * Copy a delay check list
 */
errcode_t ext2fs_copy_dclist(ext2_dclist src, ext2_dclist *dest)
{
	ext2_dclist	dclist;
	errcode_t	retval;

	retval = make_dclist(src->fs, src->size, src->count, src->list,
			     &dclist);
	if (retval)
		return retval;
	*dest = dclist;
	return 0;
}

errcode_t ext2fs_copy_dclist_range(ext2_dclist src, ext2_dclist *dest,
        unsigned long long start, unsigned long long count)
{
	ext2_dclist	dclist;
	errcode_t	retval;

	retval = make_dclist(src->fs, count, count, &src->list[start],
			     &dclist);
	if (retval)
		return retval;
	*dest = dclist;
	return 0;
}

/*
 * Merge a delay check list @src to @dest
 */
errcode_t ext2fs_merge_dclist(ext2_dclist src, ext2_dclist dest)
{
	unsigned long long src_count = src->count;
	unsigned long long dest_count = dest->count;
	unsigned long long size = src_count + dest_count;
	size_t size_entry = sizeof(struct ext2_dc_entry);
	struct ext2_dc_entry *array, *array2;
	errcode_t retval;

	if (src_count == 0)
		return 0;

	retval = ext2fs_get_array(size, size_entry, &array);
	if (retval)
		return retval;

	array2 = array;
	memcpy(array, src->list, src_count * size_entry);
	array += src_count;
	memcpy(array, dest->list, dest_count * size_entry);
	ext2fs_free_mem(&dest->list);

	dest->list = array2;
	dest->count = src_count + dest_count;
	dest->size = size;

	return 0;
}

/*
 * Close a directory block list
 *
 * (moved to closefs.c)
 */


/*
 * Add a delay check context to the delay check list
 */
errcode_t ext2fs_add_delay_check(ext2_dclist dclist, int dot_state,
        ext2_ino_t dir_ino, ext2_ino_t parent_ino)
{
	struct ext2_dc_entry 	*new_entry;
	errcode_t		retval;
	unsigned long		old_size;


	if (dclist->count >= dclist->size) {
		old_size = dclist->size * sizeof(struct ext2_dc_entry);
		dclist->size += dclist->size > 200 ? dclist->size / 2 : 100;
		retval = ext2fs_resize_mem(old_size, (size_t) dclist->size *
					   sizeof(struct ext2_dc_entry),
					   &dclist->list);
		if (retval) {
			dclist->size = old_size / sizeof(struct ext2_dc_entry);
			return retval;
		}
	}
	new_entry = dclist->list + ( dclist->count++);
	new_entry->dot_state = dot_state;
	new_entry->dir_ino = dir_ino;
	new_entry->parent_ino = parent_ino;

	return 0;
}

/*
 * Change the parent inode of directory inode to the delay check list
 */
errcode_t ext2fs_set_delay_check(ext2_dclist dclist, int dot_state,
        ext2_ino_t dir_ino, ext2_ino_t parent_ino)
{
	dgrp_t			i;

	for (i=0; i < dclist->count; i++) {
		if (dclist->list[i].dir_ino != dir_ino)
			continue;
		dclist->list[i].parent_ino = parent_ino;
		return 0;
	}
	return EXT2_ET_DB_NOT_FOUND;
}

/*
 * This function iterates over the delay check list
 */
errcode_t ext2fs_dclist_iterate2(ext2_dclist dclist,
				 int (*func)(ext2_filsys fs,
					     struct ext2_dc_entry *dc_info,
					     void	*priv_data),
				 unsigned long long start,
				 unsigned long long count,
				 void *priv_data)
{
	unsigned long long	i, end;
	int		ret;

	end = start + count;
	if (end > dclist->count)
		end = dclist->count;
	for (i = start; i < end; i++) {
		ret = (*func)(dclist->fs, &dclist->list[i], priv_data);
		if (ret & DBLIST_ABORT)
			return 0;
	}
	return 0;
}

errcode_t ext2fs_dclist_iterate(ext2_dclist dclist,
				 int (*func)(ext2_filsys fs,
					     struct ext2_dc_entry *dc_info,
					     void	*priv_data),
				 void *priv_data)
{
	return ext2fs_dclist_iterate2(dclist, func, 0, dclist->count,
				      priv_data);
}

unsigned long long ext2fs_dclist_count(ext2_dclist dclist)
{
	return dclist->count;
}

errcode_t ext2fs_dclist_get_last(ext2_dclist dclist,
				  struct ext2_dc_entry **entry)
{

	if (dclist->count == 0)
		return EXT2_ET_DBLIST_EMPTY;

	if (entry)
		*entry = dclist->list + ( dclist->count-1);
	return 0;
}


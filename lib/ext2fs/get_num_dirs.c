/*
 * get_num_dirs.c -- calculate number of directories
 *
 * Copyright 1997 by Theodore Ts'o
 *
 * %Begin-Header%
 * This file may be redistributed under the terms of the GNU Library
 * General Public License, version 2.
 * %End-Header%
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
 * Returns the number of directories in the filesystem as reported by
 * the group descriptors.  Of course, the group descriptors could be
 * wrong!
 */
errcode_t ext2fs_get_num_dirs(ext2_filsys fs, ext2_ino_t *ret_num_dirs)
{
	dgrp_t	i;
	ext2_ino_t	num_dirs, max_dirs;

	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);

	num_dirs = 0;
	max_dirs = fs->super->s_inodes_per_group;
	for (i = 0; i < fs->group_desc_count; i++) {
		if (ext2fs_bg_used_dirs_count(fs, i) > max_dirs)
			num_dirs += max_dirs / 8;
		else
			num_dirs += ext2fs_bg_used_dirs_count(fs, i);
	}
	if (num_dirs > fs->super->s_inodes_count)
		num_dirs = fs->super->s_inodes_count;

	*ret_num_dirs = num_dirs;

	return 0;
}

errcode_t ext2fs_get_ratio_dirs(ext2_filsys fs, ext2_ino_t *ret_ratio_dirs)
{
	dgrp_t	i;
	ext2_ino_t	ratio_dirs, num_dirs, max_dirs, used_dirs, used_ino;

	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);

	num_dirs = 0;
	max_dirs = fs->super->s_inodes_per_group;

	for (i = 0; i < fs->group_desc_count; i++) {
		if (ext2fs_bg_used_dirs_count(fs, i) > max_dirs)
			num_dirs += max_dirs / 8;
		else
			num_dirs += ext2fs_bg_used_dirs_count(fs, i);
	}
	if (num_dirs > fs->super->s_inodes_count)
		num_dirs = fs->super->s_inodes_count;

    used_ino = fs->super->s_inodes_count - fs->super->s_free_inodes_count;
    used_dirs = num_dirs;
    ratio_dirs = 100 * used_dirs / used_ino;
    if(used_dirs % used_ino > 0) ratio_dirs++;

	*ret_ratio_dirs = ratio_dirs;

	return 0;
}

errcode_t ext2fs_get_ratio_used(ext2_filsys fs, ext2_ino_t *ret_ratio_ino)
{
	dgrp_t	i;
	ext2_ino_t ratio_ino, used_ino;

	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
    
    used_ino = fs->super->s_inodes_count - fs->super->s_free_inodes_count;
    ratio_ino = 100 * used_ino / fs->super->s_inodes_count;
    if(used_ino % fs->super->s_inodes_count > 0) ratio_ino++;

	*ret_ratio_ino = ratio_ino;

	return 0;
}

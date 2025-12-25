/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include "imageloader.h"
#include <inttypes.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

Image* readData(char* filename) {
	FILE* file = fopen(filename, "r");

	char type[20];
	fscanf(file, "%s", type);

	Image* image = malloc(sizeof(Image));
	fscanf(file, "%u %u", &image->cols, &image->rows);
	image->image = malloc(image->rows * sizeof(Color*));
	for (int i = 0; i < image->rows; i++) {
		image->image[i] = malloc(image->cols * sizeof(Color));
	}

	int size;
	fscanf(file, "%d", &size);

	for (int i = 0; i < image->rows; i++) {
		for (int j = 0; j < image->cols; j++) {
			Color* color = &image->image[i][j];
			fscanf(file, "%hhu %hhu %hhu", &color->R, &color->G, &color->B);
		}
	}
	fclose(file);
	return image;
}

void writeData(Image* image) {
	printf("P3\n");
	printf("%u %u\n", image->cols, image->rows);
	printf("255\n");

	for (uint32_t i = 0; i < image->rows; i++) {
		for (uint32_t j = 0; j < image->cols; j++) {
			printf("%3d %3d %3d", image->image[i][j].R, image->image[i][j].G, image->image[i][j].B);

			if (j < image->cols - 1) {
				printf("   ");
			}
		}
		printf("\n");
	}
}

void freeImage(Image* image) {
	for (uint32_t r = 0; r < image->rows; ++r) {
		free(image->image[r]);
	}
	free(image->image);
	free(image);
}

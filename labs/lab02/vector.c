#include "vector.h"
#include <stdio.h>
#include <stdlib.h>

struct vector_t {
	size_t size;
	int* data;
};

static void allocation_failed() {
	fprintf(stderr, "Out of memory.\n");
	exit(1);
}

/* Bad example of how to create a new vector */
vector_t* bad_vector_new() {
	vector_t *retval, v;
	retval = &v;

	retval->size = 1;
	retval->data = malloc(sizeof(int));
	if (retval->data == NULL) {
		allocation_failed();
	}

	retval->data[0] = 0;
	return retval;
}

/* Another suboptimal way of creating a vector */
vector_t also_bad_vector_new() {
	vector_t v;

	v.size = 1;
	v.data = malloc(sizeof(int));
	if (v.data == NULL) {
		allocation_failed();
	}
	v.data[0] = 0;
	return v;
}

vector_t* vector_new() {
	vector_t* retval;

	retval = malloc(sizeof(vector_t));

	if (NULL == retval) {
		allocation_failed();
	}

	retval->size = 1;
	retval->data = malloc(sizeof(int));

	if (NULL == retval->data) {
		free(retval);
		allocation_failed();
	}

	retval->data[0] = 0;
	return retval;
}

int vector_get(vector_t* v, size_t loc) {
	if (v == NULL) {
		fprintf(stderr, "vector_get: passed a NULL vector.\n");
		abort();
	}

	if (loc < v->size) {
		return v->data[loc];
	} else {
		return 0;
	}
}

void vector_delete(vector_t* v) {
	free(v->data);
	free(v);
}

void resize_vector(vector_t* v, size_t new_size) {
	int* new_data = malloc(new_size * sizeof(int));
	if (NULL == new_data) {
		allocation_failed();
	}

	for (int i = 0; i < v->size; ++i) {
		new_data[i] = v->data[i];
	}

	for (int i = v->size; i < new_size; ++i) {
		new_data[i] = 0;
	}

	v->size = new_size;
	free(v->data);
	v->data = new_data;
}

void vector_set(vector_t* v, size_t loc, int value) {
	if (v == NULL) {
		fprintf(stderr, "vector_set: passed a NULL vector.\n");
		abort();
	} else if (loc < v->size) {
		v->data[loc] = value;
		return;
	}

	int old_size = v->size;
	old_size * 2 > loc + 1 ? resize_vector(v, old_size * 2)
						   : resize_vector(v, loc + 1);

	v->data[loc] = value;
}

#ifndef __ART_H__
#define __ART_H__

#include <art_status.h>
#include <stdio.h>

typedef struct {
  size_t name_len;
  char *name;
  size_t size;
  char *data;
} art_data_t;

typedef struct {
  size_t major;
  size_t minor;
  size_t macro;
#ifndef ART_EXCLUDE_GIT_COMMIT_FROM_VERION_STRUCT
  char git_commit[8];
#endif
} art_version_t;

typedef struct {
  const char id[4];
  const art_version_t version;
  size_t data_fields;
  art_data_t *data; // maybe linked list
} art_header_t;

typedef struct {
  const char *path;
  art_status_e status;
} art_handler_t;

static const art_version_t art_version = {
    .major = ART_MAJOR,
    .minor = ART_MINOR,
    .macro = ART_MACRO,
#ifndef ART_EXCLUDE_GIT_COMMIT_FROM_VERION_STRUCT
    .git_commit = GIT_COMMIT,
#endif
};

art_status_e create_art_handler(art_handler_t *handler);
void free_art_handler(art_handler_t *handler);

void open_art(art_handler_t *handler);
void close_art(art_handler_t *handler);

#endif // __ART_H__

#include <art.h>
#include <art_status.h>
#include <stdlib.h>

art_status_e create_art_handler(art_handler_t *handler) {
  handler = calloc(1, sizeof(art_handler_t));
  if (!handler)
    return FAIL_CALLOC;

  return OK;
}

void free_art_handler(art_handler_t *handler) {
  free((char *)handler->path);
  free(handler);
}

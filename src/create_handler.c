#include <art.h>
#include <art_status.h>
#include <stdlib.h>

art_status_e create_art_handler(art_handler_t *handler) {
  handler = calloc(1, sizeof(art_handler_t));
  if (!handler)
    return FAIL_CALLOC;
  handler->status = OK;
  return OK;
}

art_status_e free_art_handler(art_handler_t *handler) {
  if (!handler)
    return FAIL;
  if (handler->path)
    free((char *)handler->path);
  if (handler->mode)
    free((char *)handler->mode);
  if (handler->fp)
    fclose(handler->fp);
  free(handler);
  return OK;
}

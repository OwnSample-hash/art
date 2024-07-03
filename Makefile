BIN = art

CC = clang
LD = clang
AR = ar

VERSION_MAJOR = 0
VERSION_MINOR = 0
VERSION_MACRO = 1

CFLAGS += -ggdb
CFLAGS += -DART_MAJOR=${VERSION_MAJOR}
CFLAGS += -DART_MINOR=${VERSION_MINOR}
CFLAGS += -DART_MACRO=${VERSION_MACRO}
CFLAGS += -DBIN_NAME=\"${BIN}\" 
CFLAGS += -DGIT_COMMIT=\"${shell git rev-parse --short HEAD}\"
CFLAGS += -DLOG_USE_COLOR=1
CFLAGS += -DART_EXCLUDE_GIT_COMMIT_FROM_VERION_STRUCT=1
CFLAGS += -Wextra
CFLAGS += -Wall
CFLAGS += -Iinc/ 
LDFLAGS = -lm -shared

CC_U = ${shell echo ${CC}-CC | sed 's/.*/\U&/'}
LD_U = ${shell echo ${LD}-LD | sed 's/.*/\U&/'}
AR_U = ${shell echo ${AR} | sed 's/.*/\U&/'}

_MAKE_DIR = _make.dir
SRC_DIR = src
BUILD_DIR = ${_MAKE_DIR}/build

CSRCS = ${shell find ${SRC_DIR} -type f -name "*.c"}

OBJS = ${patsubst ${SRC_DIR}/%.c, ${BUILD_DIR}/%.o, ${CSRCS}}

all: backup ${BIN}
	@printf "\tDone bulding\n"

backup:
	@if [[ -f ${BIN} ]]; then \
		mv ${BIN} ${BIN}.prev; \
	fi

restore:
	mv ${BIN}.prev ${BIN}

prolog:
	@echo CC=${CC}
	@echo CFLAGS=${CFLAGS}
	@echo LDFLAGS=${LDFLAGS}
	@echo BIN=${BIN}
	@echo BUILD_DIR=${BUILD_DIR}
	@echo FULL_BD=${patsubst ${SRC_DIR}%, ${BUILD_DIR}%, ${shell find ${SRC_DIR} -type d}}
	@echo OBJS=${OBJS}
	@echo

${BUILD_DIR}:
	mkdir -p ${patsubst ${SRC_DIR}%, ${BUILD_DIR}%, ${shell find ${SRC_DIR} -type d}}

${BUILD_DIR}/%.o: ${SRC_DIR}/%.c | ${BUILD_DIR}
	@printf "\t%s  %s\n" ${CC_U} ${shell ./turn_fn.sh $<}
	@${CC} ${CFLAGS} -c $< -o $@

${BIN}: ${OBJS}
	@printf "\t%s  %s\n" ${LD_U} ${BIN}
	@${LD} ${OBJS} ${LDFLAGS} -o lib${BIN}.so
	@printf "\t%-8s  %s\n" ${AR_U} ${BIN}
	@${AR} rcs lib${BIN}.a ${OBJS}


${BUILD_DIR}/test.o: test_prog/test.c | ${BUILD_DIR}
	@printf "\t%s  %s\n" ${CC_U} ${shell ./turn_fn.sh $<}
	@${CC} ${CFLAGS} -c $< -o $@

test: ${BUILD_DIR}/test.o | ${BIN}
	@printf "\t%s  %s\n" ${LD_U} $@
	@${LD} $< lib${BIN}.a -o $@
	@printf "\tDone bulding\n"


clean:
	rm ${_MAKE_DIR} *${BIN}* test -rf

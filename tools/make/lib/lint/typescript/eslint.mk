#/
# @license Apache-2.0
#
# Copyright (c) 2017 The Stdlib Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#/

# VARIABLES #

# Define the path to the [ESLint][1] executable.
#
# To install ESLint:
#
# ```bash
# $ npm install eslint
# ```
#
# [1]: https://eslint.org/
ESLINT ?= $(BIN_DIR)/eslint

# Define the path to the ESLint configuration file:
ESLINT_TS_CONF ?= $(CONFIG_DIR)/eslint/.eslintrc.typescript.js

# Define the path to the ESLint configuration file for tests:
ESLINT_TS_CONF_TESTS ?= $(CONFIG_DIR)/eslint/.eslintrc.typescript.tests.js

# Define the path to a TypeScript configuration file:
TS_CONFIG ?= $(CONFIG_DIR)/typescript/tsconfig.json

# Define the path to the ESLint ignore file:
ESLINT_IGNORE ?= $(ROOT_DIR)/.eslintignore

# Define the command-line options to use when invoking the ESLint executable:
ESLINT_TS_FLAGS ?= \
	--ignore-path $(ESLINT_IGNORE)

ifeq ($(AUTOFIX),true)
	ESLINT_TS_FLAGS += --fix
endif

FIX_TYPE ?=
ifneq ($(FIX_TYPE),)
	ESLINT_TS_FLAGS += --fix-type $(FIX_TYPE)
endif


# RULES #

#/
# Lints TypeScript declaration files using [ESLint][1].
#
# ## Notes
#
# -   This rule is useful when wanting to glob for TypeScript declaration files (e.g., lint all TypeScript declaration files for a particular package).
#
# [1]: https://eslint.org/
#
# @private
# @param {string} [TYPESCRIPT_DECLARATIONS_FILTER] - file path pattern (e.g., `.*/math/base/special/abs/.*`)
# @param {*} [FAST_FAIL] - flag indicating whether to stop linting upon encountering a lint error
#
# @example
# make eslint-ts-declarations
#
# @example
# make eslint-ts-declarations TYPESCRIPT_DECLARATIONS_FILTER=".*/math/base/special/abs/.*"
eslint-ts-declarations: $(NODE_MODULES)
ifeq ($(FAIL_FAST), true)
	$(QUIET) $(FIND_TYPESCRIPT_DECLARATIONS_CMD) | grep '^[\/]\|^[a-zA-Z]:[/\]' | while read -r file; do \
		echo ''; \
		echo "Linting file: $$file"; \
		DIR=`dirname $$file`; \
		LOCAL_TS_CONFIG=$$DIR/tsconfig.json; \
		cp $(TS_CONFIG) $$DIR; \
		$(ESLINT) $(ESLINT_TS_FLAGS) --config $(ESLINT_TS_CONF) --parser-options=project:$$LOCAL_TS_CONFIG $$file || exit 1; \
		rm $$LOCAL_TS_CONFIG; \
	done
else
	$(QUIET) $(FIND_TYPESCRIPT_DECLARATIONS_CMD) | grep '^[\/]\|^[a-zA-Z]:[/\]' | while read -r file; do \
		echo ''; \
		echo "Linting file: $$file"; \
		DIR=`dirname $$file`; \
		LOCAL_TS_CONFIG=$$DIR/tsconfig.json; \
		cp $(TS_CONFIG) $$DIR; \
		$(ESLINT) $(ESLINT_TS_FLAGS) --config $(ESLINT_TS_CONF) --parser-options=project:$$LOCAL_TS_CONFIG $$file || echo 'Linting failed.'; \
		rm $$LOCAL_TS_CONFIG; \
	done
endif

#/
# Lints TypeScript declaration test files using [ESLint][1].
#
# ## Notes
#
# -   This rule is useful when wanting to glob for TypeScript declaration test files (e.g., lint all TypeScript declaration test files for a particular package).
#
# [1]: https://eslint.org/
#
# @private
# @param {string} [TYPESCRIPT_DECLARATIONS_TESTS_FILTER] - file path pattern (e.g., `.*/math/base/special/abs/.*`)
# @param {*} [FAST_FAIL] - flag indicating whether to stop linting upon encountering a lint error
#
# @example
# make eslint-ts-declarations-tests
#
# @example
# make eslint-ts-declarations-tests TYPESCRIPT_DECLARATIONS_TESTS_FILTER=".*/math/base/special/abs/.*"
eslint-ts-declarations-tests: $(NODE_MODULES)
ifeq ($(FAIL_FAST), true)
	$(QUIET) $(FIND_TYPESCRIPT_DECLARATIONS_TESTS_CMD) | grep '^[\/]\|^[a-zA-Z]:[/\]' | while read -r file; do \
		echo ''; \
		echo "Linting file: $$file"; \
		DIR=`dirname $$file`; \
		LOCAL_TS_CONFIG=$$DIR/tsconfig.json; \
		cp $(TS_CONFIG) $$DIR; \
		$(ESLINT) $(ESLINT_TS_FLAGS) --config $(ESLINT_TS_CONF_TESTS) --parser-options=project:$$LOCAL_TS_CONFIG $$file || exit 1; \
		rm $$LOCAL_TS_CONFIG; \
	done
else
	$(QUIET) $(FIND_TYPESCRIPT_DECLARATIONS_TESTS_CMD) | grep '^[\/]\|^[a-zA-Z]:[/\]' | while read -r file; do \
		echo ''; \
		echo "Linting file: $$file"; \
		DIR=`dirname $$file`; \
		LOCAL_TS_CONFIG=$$DIR/tsconfig.json; \
		cp $(TS_CONFIG) $$DIR; \
		$(ESLINT) $(ESLINT_TS_FLAGS) --config $(ESLINT_TS_CONF_TESTS) --parser-options=project:$$LOCAL_TS_CONFIG $$file || echo 'Linting failed.'; \
		rm $$LOCAL_TS_CONFIG; \
	done
endif

#/
# Lints a specified list of TypeScript files using [ESLint][1].
#
# ## Notes
#
# -   This rule is useful when wanting to lint a list of TypeScript files generated by some other command (e.g., a list of changed TypeScript files obtained via `git diff`).
#
# [1]: https://eslint.org/
#
# @private
# @param {string} FILES - list of TypeScript file paths
# @param {*} [FAST_FAIL] - flag indicating whether to stop linting upon encountering a lint error
#
# @example
# make eslint-ts-files FILES='/foo/test.ts /bar/index.d.ts'
#/
eslint-ts-files: $(NODE_MODULES)
ifeq ($(FAIL_FAST), true)
	$(QUIET) for file in $(FILES); do \
		echo ''; \
		echo "Linting file: $$file"; \
		DIR=`dirname $$file`; \
		LOCAL_TS_CONFIG=$$DIR/tsconfig.json; \
		cp $(TS_CONFIG) $$DIR; \
		$(ESLINT) $(ESLINT_TS_FLAGS) --config $(ESLINT_TS_CONF) --parser-options=project:$$LOCAL_TS_CONFIG $$file || exit 1; \
		rm $$LOCAL_TS_CONFIG; \
	done
else
	$(QUIET) for file in $(FILES); do \
		echo ''; \
		echo "Linting file: $$file"; \
		DIR=`dirname $$file`; \
		LOCAL_TS_CONFIG=$$DIR/tsconfig.json; \
		cp $(TS_CONFIG) $$DIR; \
		$(ESLINT) $(ESLINT_TS_FLAGS) --config $(ESLINT_TS_CONF) --parser-options=project:$$LOCAL_TS_CONFIG $$file || echo 'Linting failed.'; \
		rm $$LOCAL_TS_CONFIG; \
	done
endif

.PHONY: eslint-ts-files

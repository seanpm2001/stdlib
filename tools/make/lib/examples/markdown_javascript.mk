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

# Define the path to the remark configuration file:
REMARK_RUN_JAVASCRIPT_EXAMPLES_CONF ?= $(CONFIG_DIR)/remark/.remarkrc.js

# Define the path to the remark ignore file:
# REMARK_RUN_JAVASCRIPT_EXAMPLES_IGNORE ?= $(CONFIG_DIR)/remark/.remarkignore FIXME
REMARK_RUN_JAVASCRIPT_EXAMPLES_IGNORE ?= $(ROOT)/.remarkignore

# Define the path to a plugin which processes JavaScript examples in Markdown files:
REMARK_RUN_JAVASCRIPT_EXAMPLES_PLUGIN ?= $(TOOLS_PKGS_DIR)/remark/plugins/remark-run-javascript-examples
REMARK_RUN_JAVASCRIPT_EXAMPLES_PLUGIN_SETTINGS ?= '"'maxBuffer'"':10485760
REMARK_RUN_JAVASCRIPT_EXAMPLES_PLUGIN_FLAGS ?= --use $(REMARK_RUN_JAVASCRIPT_EXAMPLES_PLUGIN)=$(REMARK_RUN_JAVASCRIPT_EXAMPLES_PLUGIN_SETTINGS)

# Define command-line options when invoking the remark executable:
REMARK_RUN_JAVASCRIPT_EXAMPLES_FLAGS ?= \
	--ext $(MARKDOWN_FILENAME_EXT) \
	--rc-path $(REMARK_RUN_JAVASCRIPT_EXAMPLES_CONF) \
	--ignore-path $(REMARK_RUN_JAVASCRIPT_EXAMPLES_IGNORE) \
	--no-stdout \
	--no-ignore \
	--no-config \
	--quiet


# RULES #

#/
# Runs JavaScript examples found in Markdown files in sequential order.
#
# ## Notes
#
# -   This rule is useful when wanting to glob for Markdown files (e.g., run all JavaScript examples found in Markdown files for a particular package).
#
#
# @param {string} [MARKDOWN_FILTER] - file path pattern (e.g., `.*/math/base/special/abs/.*`)
#
# @example
# make markdown-examples-javascript
#
# @example
# make markdown-examples-javascript MARKDOWN_FILTER=.*/strided/common/.*
#/
markdown-examples-javascript: $(NODE_MODULES)
	$(QUIET) $(FIND_MARKDOWN_CMD) | grep '^[\/]\|^[a-zA-Z]:[/\]' | grep 'README.md' | grep -v '/_tools/' | grep -v '/stdlib/tools/' | while read -r file; do \
		echo ""; \
		echo "Running Markdown JavaScript examples: $$file"; \
		NODE_ENV="$(NODE_ENV_EXAMPLES)" \
		NODE_PATH="$(NODE_PATH_EXAMPLES)" \
		$(REMARK) $$file \
			$(REMARK_RUN_JAVASCRIPT_EXAMPLES_FLAGS) \
			$(REMARK_RUN_JAVASCRIPT_EXAMPLES_PLUGIN_FLAGS) || exit 1; \
	done

.PHONY: markdown-examples-javascript

#/
# Runs JavaScript examples found in a specified list of Markdown files in sequential order.
#
# ## Notes
#
# -   This rule is useful when wanting to run JavaScript examples found in a list of Markdown files generated by some other command (e.g., a list of changed Markdown files obtained via `git diff`).
#
#
# @param {string} FILES - list of Markdown file paths
#
# @example
# make markdown-examples-javascript-files FILES='/foo/README.md /bar/README.md'
#/
markdown-examples-javascript-files: $(NODE_MODULES)
	$(QUIET) for file in $(FILES); do \
		echo ""; \
		echo "Running Markdown JavaScript examples: $$file"; \
		NODE_ENV="$(NODE_ENV_EXAMPLES)" \
		NODE_PATH="$(NODE_PATH_EXAMPLES)" \
		$(REMARK) $$file \
			$(REMARK_RUN_JAVASCRIPT_EXAMPLES_FLAGS) \
			$(REMARK_RUN_JAVASCRIPT_EXAMPLES_PLUGIN_FLAGS) || exit 1; \
	done

.PHONY: markdown-examples-javascript-files

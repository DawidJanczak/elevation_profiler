BIN_DIR ?= webpack/node_modules/.bin

start:
	@$(BIN_DIR)/webpack-dev-server --hot -d

install:
	cd webpack && npm install --ignore-scripts

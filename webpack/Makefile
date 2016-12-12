BIN_DIR ?= node_modules/.bin

start:
	@$(BIN_DIR)/webpack-dev-server --inline --hot -d

install:
	npm install --ignore-scripts
	cd node_modules/node-sass && node scripts/install.js scripts/build.js

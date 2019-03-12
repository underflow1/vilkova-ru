const CompressionPlugin = require('compression-webpack-plugin');

const SWPrecacheWebpackPlugin = require('sw-precache-webpack-plugin');
const PUBLIC_PATH = 'https://vilkova.ru/';

module.exports = {
  runtimeCompiler: true,

  css: {
    loaderOptions: {
      sass: {
        includePaths: ['./node_modules']
      }
    }
  },

  configureWebpack: {
    plugins: [
      new SWPrecacheWebpackPlugin (
        {
          cacheId: 'vilkova-ru',
          dontCacheBustUrlsMatching: /\.\w{8}\./,
          filename: 'service-worker.js',
          minify: true,
          navigateFallback: PUBLIC_PATH,
          staticFileGlobsIgnorePatterns: [/\.map$/, /manifest\.json$/]
        }
      ),
      new CompressionPlugin()
    ]
  }
}

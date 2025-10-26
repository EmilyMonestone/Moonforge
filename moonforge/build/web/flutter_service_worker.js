'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "3dfeee6a35e680421200186aa26d4caf",
"assets/AssetManifest.bin.json": "8c87e4360cec641064042ee5751929ce",
"assets/AssetManifest.json": "c12d20b4dff2837c9e32f4f5487e6b68",
"assets/assets/icon/Contents.json": "31cc68f34934a99c0b0c1bebde56309c",
"assets/assets/icon/Moonforge-Icon-colored.appiconset/Contents.json": "570ef853cfa4e00ff21bd08028f8ac68",
"assets/assets/icon/Moonforge-Icon-colored.appiconset/Moonforge-Icon-colored_1024.png": "a9b676bfca968cb90d27516502995c8a",
"assets/assets/icon/Moonforge-Icon-colored.appiconset/Moonforge-Icon-colored_128.png": "2ff4cce36e0983ec1a930090db8b3b1f",
"assets/assets/icon/Moonforge-Icon-colored.appiconset/Moonforge-Icon-colored_16.png": "50ad55f2671ccaea7476b59f0903d741",
"assets/assets/icon/Moonforge-Icon-colored.appiconset/Moonforge-Icon-colored_256.png": "cf26184ebad687773e5d36464e99cf29",
"assets/assets/icon/Moonforge-Icon-colored.appiconset/Moonforge-Icon-colored_32.png": "dd7d65ad0e3e43f0653da3c7ec8338a4",
"assets/assets/icon/Moonforge-Icon-colored.appiconset/Moonforge-Icon-colored_512.png": "6a8ce9bc28dca418eb5a566e8fa925f4",
"assets/assets/icon/Moonforge-Icon-colored.appiconset/Moonforge-Icon-colored_64.png": "1685092f66b5b4fe41cf2db92b84aaf4",
"assets/assets/icon/Moonforge-Icon-colored.png": "a9b676bfca968cb90d27516502995c8a",
"assets/assets/icon/Moonforge-Icon-dark.appiconset/Contents.json": "ca0e696348e3d91bf0a9db9d93d87967",
"assets/assets/icon/Moonforge-Icon-dark.appiconset/Moonforge-Icon-dark_1024.png": "dcd4b98d25d186989040ebeb8cabba80",
"assets/assets/icon/Moonforge-Icon-dark.appiconset/Moonforge-Icon-dark_128.png": "17b30bbae06fc6163d54c7aa84394806",
"assets/assets/icon/Moonforge-Icon-dark.appiconset/Moonforge-Icon-dark_16.png": "6a29d6efa1aeb7e905ee7ec43e0b21fb",
"assets/assets/icon/Moonforge-Icon-dark.appiconset/Moonforge-Icon-dark_256.png": "1874a2b9f9d26cbab3bb7e97014f0cab",
"assets/assets/icon/Moonforge-Icon-dark.appiconset/Moonforge-Icon-dark_32.png": "f7d23d5de4f780509cc968139788063e",
"assets/assets/icon/Moonforge-Icon-dark.appiconset/Moonforge-Icon-dark_512.png": "98190b4f9f65a822c702b4ab94628227",
"assets/assets/icon/Moonforge-Icon-dark.appiconset/Moonforge-Icon-dark_64.png": "b4c08709aa36928e63132f1210120db8",
"assets/assets/icon/Moonforge-Icon-dark.png": "17961e27b2e1e406c0f4b5cd30bfe955",
"assets/assets/icon/Moonforge-Icon-light.appiconset/Contents.json": "70276970a00660e9243550974d412415",
"assets/assets/icon/Moonforge-Icon-light.appiconset/Moonforge-Icon-light_1024.png": "e34302991376e860858c270db42e0eba",
"assets/assets/icon/Moonforge-Icon-light.appiconset/Moonforge-Icon-light_128.png": "4ea8f951d32d72d4537898a0969b6300",
"assets/assets/icon/Moonforge-Icon-light.appiconset/Moonforge-Icon-light_16.png": "50193109972e291ae65f63ebd6cdb2ff",
"assets/assets/icon/Moonforge-Icon-light.appiconset/Moonforge-Icon-light_256.png": "da66aa7da2cbbe1b1ee8bef7adc8f933",
"assets/assets/icon/Moonforge-Icon-light.appiconset/Moonforge-Icon-light_32.png": "b9a281a29305e824f0000e624e2fe7e3",
"assets/assets/icon/Moonforge-Icon-light.appiconset/Moonforge-Icon-light_512.png": "9175f5b2cb92969575fc440f0c34cdef",
"assets/assets/icon/Moonforge-Icon-light.appiconset/Moonforge-Icon-light_64.png": "769024652fe040ab53791f360f04d02a",
"assets/assets/icon/Moonforge-Icon-light.png": "220da836acf9d96726655aedd6e8839a",
"assets/assets/icon/Moonforge-Logo-colored.appiconset/Contents.json": "6584c5dc5870914012e42acbe3049c7b",
"assets/assets/icon/Moonforge-Logo-colored.appiconset/Moonforge-Logo-colored_1024.png": "f5a1cb2e85f572b7300efa728c988aa0",
"assets/assets/icon/Moonforge-Logo-colored.appiconset/Moonforge-Logo-colored_128.png": "e78ac54a99357ffe9eb21702f8f7de37",
"assets/assets/icon/Moonforge-Logo-colored.appiconset/Moonforge-Logo-colored_16.png": "385ff724d5a22dc80c368198b5d09ada",
"assets/assets/icon/Moonforge-Logo-colored.appiconset/Moonforge-Logo-colored_256.png": "12cce6f0fe9499255f654336d253b70f",
"assets/assets/icon/Moonforge-Logo-colored.appiconset/Moonforge-Logo-colored_32.png": "185e0fb67bad08bffdeab524af91584b",
"assets/assets/icon/Moonforge-Logo-colored.appiconset/Moonforge-Logo-colored_512.png": "66a228ca9db2c1528fb5ed8db30b8dbe",
"assets/assets/icon/Moonforge-Logo-colored.appiconset/Moonforge-Logo-colored_64.png": "96c7234b0998fdea6091f0caa2c40f19",
"assets/assets/icon/Moonforge-Logo-colored.png": "5f9063a2820527ee9dd92f5a82d73cbb",
"assets/assets/icon/Moonforge-Logo-dark.appiconset/Contents.json": "e4ce170a0284df156b293368dd3b9f23",
"assets/assets/icon/Moonforge-Logo-dark.appiconset/Moonforge-Logo-dark_1024.png": "411a382d857ac6bd0905ff3f7f587108",
"assets/assets/icon/Moonforge-Logo-dark.appiconset/Moonforge-Logo-dark_128.png": "31954dba39365edfba5f79759a2d63ea",
"assets/assets/icon/Moonforge-Logo-dark.appiconset/Moonforge-Logo-dark_16.png": "2213bee29361d1177cd0485bb08e39d5",
"assets/assets/icon/Moonforge-Logo-dark.appiconset/Moonforge-Logo-dark_256.png": "67561a72d4f149859892ae55ae6deeef",
"assets/assets/icon/Moonforge-Logo-dark.appiconset/Moonforge-Logo-dark_32.png": "d2822b8d2ebdcf4d13815df9b96aee93",
"assets/assets/icon/Moonforge-Logo-dark.appiconset/Moonforge-Logo-dark_512.png": "c26d10e913483b52e9da3dd21c47c794",
"assets/assets/icon/Moonforge-Logo-dark.appiconset/Moonforge-Logo-dark_64.png": "e01d2e2fd3bafa3dd7e2e9e21666022f",
"assets/assets/icon/Moonforge-Logo-light.appiconset/Contents.json": "61ae48c2d08c2cd711e8c8c6b119cef5",
"assets/assets/icon/Moonforge-Logo-light.appiconset/Moonforge-Logo-light_1024.png": "2e9c7b7570fa832d6dceb67d349c98dc",
"assets/assets/icon/Moonforge-Logo-light.appiconset/Moonforge-Logo-light_128.png": "66c8f59752ebd3df3d32df3fa90d7912",
"assets/assets/icon/Moonforge-Logo-light.appiconset/Moonforge-Logo-light_16.png": "062dd0cd21fbc24e87904887152998bb",
"assets/assets/icon/Moonforge-Logo-light.appiconset/Moonforge-Logo-light_256.png": "160996bdd60c64623728918f0e47edf9",
"assets/assets/icon/Moonforge-Logo-light.appiconset/Moonforge-Logo-light_32.png": "1b1850eb172c3a56ad657ebf929177b5",
"assets/assets/icon/Moonforge-Logo-light.appiconset/Moonforge-Logo-light_512.png": "08bb603d5c84caf2c56c2b063ebd7a96",
"assets/assets/icon/Moonforge-Logo-light.appiconset/Moonforge-Logo-light_64.png": "9df37832282d907ec8ea4c5e7f878499",
"assets/assets/icon/Moonforge-Logo-light.png": "6a37e43ad7a01de544b1b0c25459784a",
"assets/assets/icon/MoonForge-Logo2-Icon.afdesign": "c99095f671940341e8e0e686d175f7ee",
"assets/FontManifest.json": "aed2b02323ee1c15e32a18f07088b8e3",
"assets/fonts/MaterialIcons-Regular.otf": "76212705143086bfaf31f325cc88021d",
"assets/NOTICES": "0ef8eb1fd4286a61a7ad03067bc536c6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "6ebc7bc5b74956596611c6774d8beb5b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "18b4faf1fe501f128136628e0fef3365",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "8450d0bc6e65c0ee0d77981aebfdce1d",
"icons/Icon-192.png": "28f6517e9b257b65866d860052ff367d",
"icons/Icon-512.png": "5973df9cde04ad079c227c067b1dfcc2",
"icons/Icon-maskable-192.png": "28f6517e9b257b65866d860052ff367d",
"icons/Icon-maskable-512.png": "5973df9cde04ad079c227c067b1dfcc2",
"index.html": "6bcc97c08dec8373bf7e986c0beeab20",
"/": "6bcc97c08dec8373bf7e986c0beeab20",
"main.dart.js": "c0b6fe1fa14a4b8fa19d091d650f8d2b",
"manifest.json": "c1d75a53aeb723ac8ac77a4ca561c537",
"version.json": "a9c3fed31367fbd346e77ee2d640cfa0"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

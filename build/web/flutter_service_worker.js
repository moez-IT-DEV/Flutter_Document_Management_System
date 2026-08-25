'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"main.dart.js": "f9d6354bf2afe263156fba4540ea599b",
"assets/FontManifest.json": "866b9b20ab0e8c30ffe220d2a2d66abe",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "349e8d719939cc08de240b00652a5a14",
"assets/fonts/MaterialIcons-Regular.otf": "0cad03d370eac2874f13d6ed0a446656",
"assets/assets/svg/users.svg": "b2ca2dabee70bc3620fc03979cf09e92",
"assets/assets/svg/file.svg": "a14fe422da2aeda18833c3074ead940f",
"assets/assets/svg/pdf.svg": "5096181ae280e3ee3496cc38cc710905",
"assets/assets/svg/document.svg": "d785e3a9ab06face20833209fd032c4b",
"assets/assets/svg/setting.svg": "8a3f90d2140fe88eb6f79728edeff50e",
"assets/assets/svg/assigned.svg": "acb2c15595504d0f424ca580337dfa1b",
"assets/assets/svg/audit.svg": "a44f3ba0a45bfe74706c4f0c283b61d4",
"assets/assets/images/country.png": "ba0b32cd1fbb3979a1baee8edccbe94e",
"assets/assets/images/d_logout.png": "6c16e400bfa5e5ce3e1c377938ea431b",
"assets/assets/images/otp_image.png": "f094f390a538020c87dc6990c598fdb2",
"assets/assets/images/referral.png": "90971584115388b5fe9e40f00dd0a636",
"assets/assets/images/settings.png": "5dc77fae9b66248399ad2b026f38f0eb",
"assets/assets/images/conversion_rate.png": "550308a0ebc2c3d552beb069e57629aa",
"assets/assets/images/category.png": "22e4c27352075c67eaec116997c87ec5",
"assets/assets/images/d_referral.png": "68f7ac5e384226374d708bccbe957fb8",
"assets/assets/images/charge.png": "7229f3c96139c52e947781d6e49ebd15",
"assets/assets/images/error.png": "09f839c4c15e739c3e1c5c99b3f04288",
"assets/assets/images/purchase_log.png": "afa05dcd62f695e532e6bbb71265ce53",
"assets/assets/images/address.png": "4d721f2a7fb6659c3eac7e54153bbbe7",
"assets/assets/images/zip_code.png": "34413eeb1a8de7de6ede2682c3661e12",
"assets/assets/images/state.png": "95b4f83797facfec96d5280d2f3aa3b6",
"assets/assets/images/check_mark.png": "ba1dcb9761ac76b08b0f6447f4e932e5",
"assets/assets/images/reset_pass_image.png": "513f8187b3a429899080aa71cc8ec9b0",
"assets/assets/images/filter.png": "3e6e1584da8fe309b1c1bde69d221885",
"assets/assets/images/running.png": "bc8bc52da05c30772fdc78d9a18c66d5",
"assets/assets/images/d_withdraw.png": "f49c805a63694c7ac544696c7ec49892",
"assets/assets/images/categories.png": "f495d990648346a9c8bb29922d6fda47",
"assets/assets/images/wallet.png": "a2c1ce706ea1aa982c386d0f41f83e8f",
"assets/assets/images/limit.png": "439f0735074df8a49143f617ded4bb2a",
"assets/assets/images/change_pass.png": "95623b38794cda7c4c2ef1a292b15e40",
"assets/assets/images/mark.png": "74551b00e0c3a77f2684ccf1807144f4",
"assets/assets/images/documentsill.png": "b8d38b09c7d95aaa502931692d1508fa",
"assets/assets/images/d_change_pass.png": "c4b58a8c0c8f9ae99de2f5bb77eb2a68",
"assets/assets/images/rejected.png": "b72fee4487bf717518e22dc4d08dd622",
"assets/assets/images/verified.svg": "9525aee8948f0a4de00aaf2edc3ff5f9",
"assets/assets/images/email.png": "20403492446d12a7891412786253c44a",
"assets/assets/images/users.png": "4007b3bf5a58579a23f788639fdaafc0",
"assets/assets/images/znet.png": "6b837d3fe6230cd054cc64398a4b4668",
"assets/assets/images/DocumentIllustration.jpg": "188e17c043c346d4c3289b921d526b87",
"assets/assets/images/plan.png": "bd1a0424f79fdf29380389763183ce7e",
"assets/assets/images/menu.png": "0d6cfb144ff51a50d6e374e956d99f38",
"assets/assets/images/menu_image.png": "925ddba4e93a9fdb6831ddc99f8994fc",
"assets/assets/images/user.png": "29479ba0435741580ca9f4a467be6207",
"assets/assets/images/d_policy.png": "11c5e1289e01c3d7c871ed5bc8ee8aad",
"assets/assets/images/no_data.png": "622a8e6bf2c608b39590847334da1201",
"assets/assets/images/pending.svg": "5c159114b01d47b2325dfc31fff49b29",
"assets/assets/images/dots.png": "2d69dae48c292aedf0962a0f6c711079",
"assets/assets/images/document_audit.png": "c554532ebc9c53eb1a03d4ff9d4f8e8a",
"assets/assets/images/assigned.png": "f521e9779a6f08e3d41fbbe51c03f722",
"assets/assets/images/home.png": "006b72873f5c0786ffabba77259375fa",
"assets/assets/images/city.png": "076ade74d801a1fa27d5d5e0c17d0674",
"assets/assets/images/avatar.png": "64598bc8e88c415e65afd8ed4c361778",
"assets/assets/images/pending.png": "f94374fcf5450c58e25292bd7922eefd",
"assets/assets/images/all_documents.png": "540c5e86928eadf9c34fb7c116a0ba29",
"assets/assets/images/person.png": "fd9bfdccfe3ee06f908fd3b0ae74bf1b",
"assets/assets/images/phone.png": "cb41e872a58a7517a67c2411d8e02b11",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/syncfusion_flutter_pdfviewer/assets/strikethrough.png": "cb39da11cd936bd01d1c5a911e429799",
"assets/packages/syncfusion_flutter_pdfviewer/assets/fonts/RobotoMono-Regular.ttf": "5b04fdfec4c8c36e8ca574e40b7148bb",
"assets/packages/syncfusion_flutter_pdfviewer/assets/underline.png": "c94a4441e753e4744e2857f0c4359bf0",
"assets/packages/syncfusion_flutter_pdfviewer/assets/squiggly.png": "c9602bfd4aa99590ca66ce212099885f",
"assets/packages/syncfusion_flutter_pdfviewer/assets/highlight.png": "7384946432b51b56b0990dca1a735169",
"assets/AssetManifest.bin.json": "1a2afb1cdf8c15acc819774f4125a726",
"assets/AssetManifest.json": "0d7784f94d52a44f77dc6d24372fb32d",
"assets/AssetManifest.bin": "70ab3524b1ed5dc92b17ba320456c2ab",
"manifest.json": "da04ad6cca4ff07d72911df0fa32fa6e",
"version.json": "6d91760d048e9465fcea625c5cd69610",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"index.html": "fe95dff4af0fec5aa7c97e740535fafa",
"/": "fe95dff4af0fec5aa7c97e740535fafa",
"flutter_bootstrap.js": "98c2116f22104d576b84b2705d471271",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"favicon.png": "5dcef449791fa27946b3d35ad8803796"};
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

<maptest>
  <div class="wrapper">
    <aside>
      <section>
        <h1 class="site-title"><a href="/">lib(where)y</a></h1>

        <div class="near-me">
          <a class="near-me-text" href="" onclick={ nearMe }><span>view libraries near me</span></a>
          <span class="near-me-error" if={ nearMeError }>{ nearMeError }</span>
        </div>
        <div class="library-list">
          <ul>
            <li class='library-entry' each={ library in libraries } onclick={ onClickSidebar }>
              { library.address }
              <img class='library-thumbnail' if={ library.photos } src={ library.photos }>
            </li>
          </ul>
        </div>
      </section>

      <footer>made by <a href="https://shirleyyin.com">shirley yin</a> · <a href="/about">about this site</a></footer>
    </aside>
    <main>
      <div id="map"></div>
    </main>
  </div>


  <script>
    const self = this;
    self.libraries = [];
    self.markers = new Map();
    self.map = null;
    self.nearMeError = null;

    self.on('mount', function() {
      initializeMap();
      getLibraries();
    })

    nearMe(e) {
      e.preventDefault();
      navigator.geolocation.getCurrentPosition((position) => {
        centerMap(position.coords.latitude, position.coords.longitude);
        getLibraries(position.coords.latitude, position.coords.longitude);
        self.nearMeError = null;
        self.update();
      }, (error) => {
        self.nearMeError = `There was an error getting your location: ${error.message}`;
        self.update();
      });
    }

    onClickSidebar(e) {
      const selectedLibrary = e.item.library;

      centerMap(selectedLibrary.location.latitude, selectedLibrary.location.longitude);
      openMapPopup(selectedLibrary);
    }

    const initializeMap = function() {
      self.map = L
        .map('map')
        .setView([49.282730, -123.120735], 13)
        .on('zoomend', reloadMap)
        .on('dragend', reloadMap);

      L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
          attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
          maxZoom: 18,
          id: 'mapbox/streets-v11',
          tileSize: 512,
          zoomOffset: -1,
          accessToken: opts.mapboxApiKey,
      }).addTo(self.map);
    }

    const getMarker = function() {
      return L.icon({
        iconUrl: '/static/web/assets/marker.png',
        iconSize: [40, 40],
        iconAnchor: [20, 40],
        popupAnchor: [0, -20],
        shadowUrl: null,
        shadowSize: null,
        shadowAnchor: null,
      });
    }

    const getLibraries = function(latitude, longitude, radius) {
      const params = new URLSearchParams();
      if (latitude && longitude) {
        params.append('location', `${latitude},${longitude}`);
      }
      if (radius) {
        params.append('radius', radius)
      }

      const apiUrl = `/api/libraries?${params.toString()}`;
      fetch(apiUrl, {method: 'GET', mode: 'cors'}).then(response => {
        response.json().then(data => {
          self.libraries = data;
          self.update();

          addMapMarkers();
        });
      }).catch(error => {
        console.log('error', error);
      });
    }

    const addMapMarkers = function() {
      const currentMarkers = new Set();
      self.libraries.forEach(library => {
        const hash = JSON.stringify(library.location);
        const marker = self.markers.get(hash) ?? L.marker(
          [library.location.latitude, library.location.longitude], {
            ...library,
            icon: getMarker()})
          .addTo(self.map)
          .on('click', onClickMarker);
        currentMarkers.add(hash);
        self.markers.set(hash, marker);
      });
      for (const [hash, marker] of self.markers[Symbol.iterator]()) {
        if (!currentMarkers.has(hash)) { 
          self.markers.delete(hash);
          marker.remove();
        }
      }
    }

    const onClickMarker = function(e) {
      const markerId = e.target.options.id;
      openMapPopup(e.target.options);
    }

    const centerMap = function(latitude, longitude) {
      self.map.setView(new L.latLng(latitude, longitude), 13);
    }

    const reloadMap = function(e) {
      const center = self.map.getCenter();
      const bounds = self.map.getBounds();

      const mapDistanceSpan = haversine(
        bounds._northEast, bounds._southWest,
        {format: '{lat,lng}', unit: 'km'});
      const radius = mapDistanceSpan / 2;

      getLibraries(center.lat, center.lng, radius);
    }

    const openMapPopup = function(library) {
      const popup = L.popup({
        offset: L.point(0, -25),
        closeButton: false,
      });

      popup
        .setLatLng(new L.latLng(library.location.latitude, library.location.longitude))
        .setContent(`${library.address}<br><em>Source: ${library.source_display}</em>`)
        .openOn(self.map);
    }

  </script>
</maptest>

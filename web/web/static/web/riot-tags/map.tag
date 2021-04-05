<maptest>
  <div class="wrapper">
    <aside>
      <section>
        <h1 class="site-title">lib(where)y</h1>

        <div class="near-me">
          <a href="" onclick={ nearMe }><span>view libraries near me</span></a>
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

      <footer>made by <a href="https://shirleyyin.com">shirley yin</a> · <a href="">about this site</a></footer>
    </aside>
    <main>
      <div id="map"></div>
    </main>
  </div>


  <script>
    const self = this;
    self.libraries = [];
    self.map = null;

    self.on('mount', function() {
      initializeMap();
      getLibraries();
    })

    nearMe(e) {
      e.preventDefault();
      console.log('here');
      navigator.geolocation.getCurrentPosition((position) => {
        console.log('position', position)
        centerMap(position.coords.latitude, position.coords.longitude);
        getLibraries(position.coords.latitude, position.coords.longitude);
      });
    }

    onClickSidebar(e) {
      const selectedLibrary = e.item.library;
      console.log("onclicksidebar", selectedLibrary);

      centerMap(selectedLibrary.location.latitude, selectedLibrary.location.longitude);
      openMapPopup(selectedLibrary);
    }

    const initializeMap = function() {
      self.map = L
        .map('map')
        .setView([49.282730, -123.120735], 13)
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

    const getLibraries = function(latitude, longitude) {
      const queryParams = latitude && longitude ? `?location=${latitude},${longitude}` : '';
      const apiUrl = `/api/libraries${queryParams}`;
      console.log('apiUrl', apiUrl);
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
      self.libraries.forEach(library => {
        const marker = L.marker(
          [library.location.latitude, library.location.longitude], {
            ...library,
            icon: getMarker()})
          .addTo(self.map)
          .on('click', onClickMarker);
      });
    }

    const onClickMarker = function(e) {
      const markerId = e.target.options.id;
      console.log('onClickMarker', markerId, e.target.options.address)

      openMapPopup(e.target.options);
    }

    const centerMap = function(latitude, longitude) {
      self.map.setView(new L.latLng(latitude, longitude));
    }

    const reloadMap = function(e) {
      console.log('reloadMap', e);
    }

    const openMapPopup = function(library) {
      const popup = L.popup({
        offset: L.point(0, -20)
      });

      popup
        .setLatLng(new L.latLng(library.location.latitude, library.location.longitude))
        .setContent(library.address)
        .openOn(self.map);

      console.log('popup', popup, library.location.latitude, library.location.longitude)
    }

  </script>
</maptest>
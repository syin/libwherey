<maptest>
  <div class="wrapper">
    <aside>
      <section>
        <h1 class="site-title">lib(where)y</h1>

        <button type="button" class="near-me" onclick={ nearMe }>near me</button>
        <div class="library-list">
          <ul>
            <li class='library-entry' each={ library in libraries }>
              { library.address }
              <img class='library-thumbnail' if={ library.photos } src={ library.photos }>
            </li>
          </ul>
        </div>
      </section>

      <footer>Made by <a href="https://shirleyyin.com">Shirley Yin</a> · <a href="">About this app</a></footer>
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

    nearMe() {
      console.log('here');
    }

    const initializeMap = function() {
      self.map = L.map('map').setView([49.282730, -123.120735], 13);

      L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
          attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
          maxZoom: 18,
          id: 'mapbox/streets-v11',
          tileSize: 512,
          zoomOffset: -1,
          accessToken: opts.mapboxApiKey,
      }).addTo(self.map);
    }

    const getLibraries = function() {
      const apiUrl = `/api/libraries`;
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
        const marker = L.marker([library.location.latitude, library.location.longitude]).addTo(self.map);
      });
    }

  </script>
</maptest>
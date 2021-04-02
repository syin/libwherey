<maptest>
  <div class="wrapper">
    <nav>
      <h1 class="site-title">lib(where)y</h1>

      <button type="button" class="near-me" onclick={ nearMe }>near me</button>
      <div class="library-list">
        <ul>
          <li each={ library in libraries }>
            { library.location }
          </li>
        </ul>
      </div>
    </nav>
    <main>
      <div id="map">
          test
      </div>
    </main>
  </div>


  <script>
    const self = this;
    self.libraries = [];

    const testLibraries = [
    {
      "location": "abc st & 123 ave",
    },
    {
      "location": "abc st & 123 ave",
    }
    ]

    self.on('mount', function() {
      initializeMap();
      getLibraries();
    })

    nearMe() {
      console.log('here');
    }

    const initializeMap = function() {
      const map = L.map('map').setView([49.282730, -123.120735], 13);

      L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
          attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
          maxZoom: 18,
          id: 'mapbox/streets-v11',
          tileSize: 512,
          zoomOffset: -1,
          accessToken: opts.mapboxApiKey,
      }).addTo(map);
    }

    const getLibraries = function() {
      // TODO api

      self.libraries = testLibraries;
      self.update();
    }

  </script>
</maptest>
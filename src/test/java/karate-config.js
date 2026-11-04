function fn() {
    var config = {
      baseUrl: 'https://serverest.dev'
    };

    karate.configure('connectTimeout', 10000);
    karate.configure('readTimeout', 10000);

    return config;
  }

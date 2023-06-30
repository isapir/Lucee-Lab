component {

    this.name = "LuceeLab";

    // this.mappings["/mnt/lucee-src-cfml-context"] = "/mnt/lucee-src-cfml-context";
    
    this.datasources["postgres"] = {
        class: "org.postgresql.Driver", 
        bundleName: "org.postgresql.jdbc", 
    //  bundleVersion: "42.2.18",
        connectionString: "jdbc:postgresql://postgres:5432/postgres",
        username: "postgres",
        password: "s3cret",
    //  password: "encrypted:e890e9402dafdf6c1b0d3dfc6e2d148c181fc5ca54f74cdf",
    };

    this.datasource = this.datasources.postgres;

    this.cache.connections["redis"] = {
		class: 'lucee.extension.io.cache.redis.simple.RedisCache',
		bundleName: 'redis.extension',
	//	bundleVersion: '3.0.0.48',
		storage: false,
		custom: {
			"secretKey":"",
			"minIdle":"0",
			"secretName":"",
			"maxTotal":"24",
			"maxIdle":"8",
			"maxLowPriority":"0",
			"host":"redis",
			"accessKeyId":"",
			"password":"",
			"idleTimeout":"300000",
			"liveTimeout":"3600000",
			"region":"",
			"port":"6379",
			"timeToLiveSeconds":"0",
			"socketTimeout":"2000",
			"username":"",
			"connectionTimeout":"5000"
		},
	//	default: ''
	};

}

对网络请求的封装, 支持GET POST PUT DELETE (Network requests wrapper (support GET/POST/PUT/DELETE))
===============

Demo:

	NetworkManager *manager = [NetworkManager sharedInstance];
	
	    [manager requestDataWithURL:@"http://..." method:@"POST" parameter:dict header:header body:body timeoutInterval:10.0 result:^(int *operation, id responseObject) {
	        
	    } failure:^(int *operation, NSError *error) {
	        
	    }];

	 [manager requestDataWithURL:@"http://..." method:@"GET" parameter:dict header:nil body:nil timeoutInterval:10.0 result:^(int *operation, id responseObject) {
		        
		    } failure:^(int *operation, NSError *error) {
		        
		    }];
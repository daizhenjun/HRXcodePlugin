import BaseHTTPServer, httplib, SocketServer, urllib, sys
import c_notice

class ProxyHTTPRequestHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    
	def doCommon(self):
		req = Request(self)
		req.delHeaders("accept-encoding", "host", "proxy-connection")
		
		res = req.getResponse()
		res.delHeader("transfer-encoding")
		res.toClient()
    
	def do_GET(self):
		self.doCommon()
    
	def do_POST(self):
		self.doCommon()

class Request:
	def __init__(self, proxy):
		self.proxy = proxy
		self.host = proxy.headers.getheader("host")
		self.command = proxy.command
		self.path = proxy.path
		self.headers = proxy.headers.dict
		self.conn = httplib.HTTPConnection(self.host)#, timeout=240
		print "================client request================="
		print self.command
		print self.path
		print "================head content================="
		print repr(self.headers)
		if self.command == "POST":
			self.body = self.proxy.rfile.read(\
                                              int(self.proxy.headers.getheader("content-length")) )
			print "================body content================="
			print repr(self.body)
		else:
			self.body = None
		print "================ end================="
		c_notice.requestCallBack("usage", "only call back")
	
	def getHeader(self, k):
		if self.headers.has_key(k):
			return self.headers[k]
		else:
			return None

	def setHeader(self, k, v):
		self.headers[k] = v

	def setHeaders(self, dict):
		for i in dict.items():
			self.setHeader(i[0], i[1])

	def delHeader(self, k):
		if self.headers.has_key(k):
			del self.headers[k]

	def delHeaders(self, *list):
		for l in list:
			self.delHeader(l)

	def bodyDecode(self):
		m = MapList()
		for b in self.body.split("&"):
			for p in b.split("="):
				if p != "":
					m.add(urllib.unquote_plus(p[0]),
                          urllib.unquote_plus(p[1]))
		return m

	def bodyEncode(self, mapList):
		body = ""
		for k in mapList.keys():
			for l in mapList.getList(k):
				body += "%s=%s&" % (urllib.quote_plus(k),
									urllib.quote_plus(l))
		if body == "":
			self.body = None
		else:
			self.body = body[:-1]

	def getResponse(self):
		if self.body:
			self.headers["content-length"] = str(len(self.body))
			self.conn.request("POST", self.path, self.body, self.headers)
		else:
			self.conn.request("GET", self.path, headers=self.headers)

		return Response(self.proxy, self.conn.getresponse())

class Response:
	def __init__(self, proxy, server):
		self.proxy = proxy
		self.server = server
		self.status = server.status
		self.body = server.read()
		
		self.headers = MapList()
		for l in server.getheaders():
			self.headers.add(l[0], l[1])

	def getHeader(self, k, index=-1):
		if self.headers.hasKey(k, index):
			return self.headers.get(k, index)
		else:
			return None

	def setHeader(self, k, v, index=-1):
		self.headers.set(k, v, index)

	def addHeader(self, k, v):
		self.headers.add(k, v)

	def addHeaders(self, dict):
		for i in dict.items():
			self.setHeader(i[0], i[1])

	def delHeader(self, k):
		if self.headers.hasKey(k):
			self.headers.delMap(k)

	def delHeaders(self, *list):
		for l in list:
			self.delHeader(l)

	def toClient(self):
        	print "================server response================="
		print self.status #print res.status, res.reaso
		self.proxy.send_response(self.status)
		print "================head content================="
		for k in self.headers.keys():
            		for l in self.headers.getList(k):
                		self.proxy.send_header(k, l)
                		print k, l
  		self.proxy.wfile.write(self.body)
        	mybody = self.body
        	self.proxy.end_headers()
        	print "================body content================="
        	print repr(self.body)
        	print "================response end================="
        	c_notice.responseCallBack("usage", "only call back")

class MapList:
	def __init__(self):
		self.map = {}
	
	def __str__(self):
		return str(self.map)
    
	def add(self, k, v):
		if self.map.has_key(k):
			self.map[k].append(v)
		else:
			self.map[k] = [v]

	def set(self, k, v, index=-1):
		if self.map.has_key(k):
			self.map[k][index] = v
		else:
			self.map[k] = [v]

	def get(self,k, index=-1):
		return self.map[k][index]

	def getList(self,k):
		return self.map[k]

	def delMap(self, k):
		if self.map.has_key(k):
			del self.map[k]

	def delList(self, k, index=-1):
		if self.map.has_key(k):
			del self.map[k][index]

	def hasKey(self, k, index=-1):
		if self.map.has_key(k):
			l = self.map[k]
			if index < 0:
				index += 1
			if len(l) > abs(index):
				return True
		return False

	def keys(self):
		return self.map.keys()

	def mapSize(self):
		return len(self.map)

	def listSize(self, k):
		if self.map.has_key(k):
			return len(self.map[k])
		else:
			return 0

	def size(self):
		size = 0
		for i in self.map.items():
			size += len(i[1])
		return size

class ThreadingHTTPServer(SocketServer.ThreadingTCPServer, BaseHTTPServer.HTTPServer):
	pass

def test():
    try:
        HandlerClass = ProxyHTTPRequestHandler
        ServerClass = ThreadingHTTPServer
        BaseHTTPServer.test(HandlerClass, ServerClass)
    except:
        print "sering exit!"
        sys._exit(1)

test()
#if __name__ == '__main__':
#    test()

import datetime
from flask import Flask, Response, request

clients = {}

app = Flask(__name__)
app.debug = True
 
@app.route("/", methods=["GET"])
def getClients():
    result = ""
    if not clients:
        result = "No Clients Registered" 
    else:        
        for instanceId,registeredAt in clients.iteritems():
            result += "{0} {1:%Y-%m-%d %H:%M:%S}\n".format(instanceId,registeredAt)
    result += "\n"
    return Response(result,mimetype="text/plain")

@app.route("/", methods=["PUT", "POST"]) 
def putClient():    
    instanceId = request.form["instanceId"]
    registeredAt = datetime.datetime.now()    
    clients[instanceId] = registeredAt
    return getClients()

@app.route("/", methods=["DELETE"])
def deleteClients():
    clients.clear()
    return getClients()
    
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)
####################################################################################
# Sample script that can be used to execute tests against running Docker container.#
####################################################################################

response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5555 -u Administrator:manage)
echo $response
if [ "$response" != "200" ]
 then
 echo "5555 port is down"
 exit 1
fi
import http.requests.*;

class LoyaltyAPI
{
  private String customerID;
  private final String APIEndpoint = "https://cs1.ucc.ie/~iw2";

LoyaltyAPI(String ID) {
  customerID = ID;
}



public int getBeerStamps() {
  GetRequest get = new GetRequest(APIEndpoint + "/voucher/" + customerID);
  get.send();
  int stamps = Integer.parseInt(get.getContent());
  return stamps;
  
}

public void resetCard() {
  GetRequest get = new GetRequest(APIEndpoint + "/reset/" + customerID);
  get.send();
  }
}

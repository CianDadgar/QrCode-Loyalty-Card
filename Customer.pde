class Customer
{
  private String name;
  private String ID;
  private String created;

  Customer(String json) {
    JSONObject customer = parseJSONObject(json);
    this.name = customer.getString("name");
    this.ID = customer.getString("ID");
    this.created = customer.getString("created");
  }
  public String getID() {
    return this.ID;
  }

  public String getName () {
    return this.name;
  }
  public String getCreated() {
    return this.created;
  }
}

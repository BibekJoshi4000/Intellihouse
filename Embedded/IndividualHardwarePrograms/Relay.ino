#define relay 21;
void setup() {
  pinMode(relay, OUTPUT);

}

void loop() {
  digitalWrite(relay, HIGH);
  delay(1000);
  digitalWrite(relay, LOW);
  delay(1000);
}

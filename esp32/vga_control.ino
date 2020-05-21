// -*- c++ -*-

#define SPR_CLK  21
#define SPR_CMD  22
#define SPR_SER  23

#define WIDTH  640
#define HEIGHT 480
#define BORDER 10

void spr_send_cmd(uint8_t cmd, uint16_t data)
{
  digitalWrite(SPR_CMD, 0);

  char buf[17];
  const int bit_delay = 0;
  
//  Serial.println("=================");

  // send command data
  for (int i = 0; i < 4; i++) {
    digitalWrite(SPR_SER, (cmd >> (3-i)) & 1);
    buf[i] = ((cmd >> (3-i)) & 1) ? '1' : '0';
    if (bit_delay) delay(bit_delay);
    digitalWrite(SPR_CLK, 1);
    if (bit_delay) delay(bit_delay);
    digitalWrite(SPR_CLK, 0);
  }
  buf[4] = '\0';
  //Serial.println(buf);

  // send param data
  for (int i = 0; i < 16; i++) {
    digitalWrite(SPR_SER, (data >> (15-i)) & 1);
    buf[i] = ((data >> (15-i)) & 1) ? '1' : '0';
    if (bit_delay) delay(bit_delay);
    digitalWrite(SPR_CLK, 1);
    if (bit_delay) delay(bit_delay);
    digitalWrite(SPR_CLK, 0);
  }
  buf[16] = '\0';
  //Serial.println(buf);

  // send command bit
  digitalWrite(SPR_SER, 0);
  digitalWrite(SPR_CMD, 1);
  if (bit_delay) delay(bit_delay);
  digitalWrite(SPR_CLK, 1);
  if (bit_delay) delay(bit_delay);
  digitalWrite(SPR_CLK, 0);
  digitalWrite(SPR_CMD, 0);
}

void process_counters(void)
{
  static int x = 0;
  static int y = 0;
  static int p = 0;
  static int dx = 1;
  static int dy = 1;
  static int dp = 1;
  static int color = 6;
  static unsigned long start_ts = millis();
  static unsigned long last_ts = 0;

  unsigned long cur_ts = millis();
  if (last_ts == 0) {
    spr_send_cmd(1, 1);
    spr_send_cmd(2, 0);
    spr_send_cmd(4, 100);
    spr_send_cmd(3, 0);
    spr_send_cmd(5, 100);
    spr_send_cmd(6, color+1);
    last_ts = cur_ts;
  } else if (cur_ts - start_ts > 1000 && cur_ts - last_ts > 2) {
    //spr_send_cmd(count & 0xf, 0);
    x += dx;
    y += dy;
    p += dp;
    if (x <  BORDER)            { x = BORDER;            dx =  1; color = (color+1)%7; }
    if (x >= WIDTH-BORDER-100)  { x = WIDTH-BORDER-101;  dx = -1; color = (color+1)%7; }
    if (y <  BORDER)            { y = BORDER;            dy =  1; color = (color+1)%7; }
    if (y >= HEIGHT-BORDER-100) { y = HEIGHT-BORDER-101; dy = -1; color = (color+1)%7; }
    if (p >= 10*BORDER || p <= -10*BORDER) { dp = -dp; }
    spr_send_cmd(2, x+p/10);
    spr_send_cmd(4, x-2*p/10+100);
    spr_send_cmd(3, y-p/10);
    spr_send_cmd(5, y+2*p/10+100);
    spr_send_cmd(6, color+1);
    last_ts = cur_ts;
  }
}

void setup(void)
{
  pinMode(SPR_CLK, OUTPUT);
  pinMode(SPR_CMD, OUTPUT);
  pinMode(SPR_SER, OUTPUT);
  
  digitalWrite(SPR_CMD, 0);
  
  Serial.begin(115200);
  Serial.println("=== STARTING ================");
}

void loop(void)
{
  process_counters();
}

### Para crear y transferir objeto en una sola transaccion
## Siempre tenemos que aclarar a que cuenta vamos a enviar el objeto porque no puede quedar huerfano
sui client ptb \
  --move-call 0x2d809070844f458e5bcb1164220ec8ee2c1e5d55967b2239596be329c56f748a::entries::create_basic_shield \
  --assign shield \
  --transfer-objects "[shield]" @0xf3bbf88652e24c54c70b6b4f91d5885744c5346044c4e9ebb625d543b11681ba \
  --gas-budget 100000000


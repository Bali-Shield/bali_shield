### Para crear y transferir objeto en una sola transaccion
## Siempre tenemos que aclarar a que cuenta vamos a enviar el objeto porque no puede quedar huerfano
sui client ptb \
  --move-call <PACKAGE_ID>::entries::create_basic_shield \
  --assign shield \
  --transfer-objects "[shield]" @0x1738b9940a8c3a33e8bbbbf186c19d6af54d0fc23affbd0607d6d47a582e9b70 \
  --gas-budget 100000000

sui client call   --package 0xf0b594932e047fc40c15c3ce6002f8bcaaeb47902949a64ec5a105410e0ec3e0   --module entries   --function upgrade_basic_to_advanced   --args 0x424bad4dd9b28c835b879dded6fa9bfa7b0d3a15ec05dd08286ebf4c725bb213 0x3f7c41a62c2476b103923cba5bbb1b344124cc7103d83068a07fee29e719e7c1   --gas-budget 100000000

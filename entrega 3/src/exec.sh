#!/bin/bash

# Colores para el texto
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Función para imprimir mensajes bonitos
print_message() {
  echo -e "${BLUE}==============================${NC}"
  echo -e "${GREEN}$1${NC}"
  echo -e "${BLUE}==============================${NC}"
}

# Ensamblar el archivo .S
print_message "Assembling protectedMode.S"
as -g -o protectedMode.o protectedMode.S
if [ $? -eq 0 ]; then
  echo -e "${YELLOW}protectedMode.S assembled successfully!${NC}"
else
  echo -e "${RED}Error assembling protectedMode.S!${NC}"
  exit 1
fi

# Enlazar el archivo objeto a un archivo binario
print_message "Linking to create protectedMode.img"
ld --oformat binary -o protectedMode.img -T link.ld protectedMode.o
if [ $? -eq 0 ]; then
  echo -e "${YELLOW}protectedMode.img created successfully!${NC}"
else
  echo -e "${RED}Error linking protectedMode.o!${NC}"
  exit 1
fi

# Ejecutar la imagen con QEMU
print_message "Running protectedMode.img with QEMU"
qemu-system-x86_64 -hda protectedMode.img
if [ $? -eq 0 ]; then
  echo -e "${YELLOW}QEMU executed successfully!${NC}"
else
  echo -e "${RED}Error executing QEMU!${NC}"
  exit 1
fi

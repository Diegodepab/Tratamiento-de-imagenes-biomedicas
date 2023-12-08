# -*- coding: utf-8 -*-
"""
Created on Fri Dec  8 22:51:28 2023

DiegoDePab
"""


#pip install Pillow #instala la ultima version de pillow, libreria de procesado de imagenes en Python
from PIL import Image 
import os #modulo que permite interactuar con el sistema operativo subyacente (interactuar con archivos)

carpeta = "AQUI LA DIRECCION DE TU CARPETA"
if __name__ == "__main__":
    for filename in os.listdir(carpeta):
        nombre, formato = os.path.splitext(carpeta + filename)

        if formato in [".jpg", ".png"]:
            picture = Image.open(carpeta + filename)
            picture.save(carpeta + "_comprimido"+filename, optimize=True, quality=80) #quality predeterminado 75

print("Todas las imagenes dentro de la carpeta dada han sido procesadas")
#https://pypi.org/project/Pillow/ pagina para ver mas sobre pillow
#https://pillow.readthedocs.io/en/stable/reference/Image.html pagina deL modulo Image DE Pillow
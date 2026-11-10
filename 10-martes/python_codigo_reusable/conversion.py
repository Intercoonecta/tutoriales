import math


def rapidez_angulo_a_u_v(rapidez, angulo):
    """
    Convertir un vector de velocidad de (rapidez, angulo) a (u, v)
    """
    u = rapidez * math.sin(math.radians(angulo))
    v = rapidez * math.cos(math.radians(angulo))
    return u, v

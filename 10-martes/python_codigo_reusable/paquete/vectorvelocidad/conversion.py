import math


def rapidez_angulo_a_u_v(rapidez: float, angulo: float): -> tuple(float, float)
    """
    Convertir un vector de velocidad de (rapidez, angulo) a (u, v)
    
    Parameters
    ----------
    rapidez : float
              Magnitud del vector de velocidad
    angulo : float
             Ángulo en la convención geográfica, en grados, donde los 
             valores aumentan en el sentido del reloj de 0, Norte, a 360
    
    Returns
    -------
    tuple(float, float)
             Componentes de la velocidad en la dirección Este, `u`, y Norte, `v`
    """
    
    u = rapidez * math.sin(math.radians(angulo))
    v = rapidez * math.cos(math.radians(angulo))
    
    return u, v

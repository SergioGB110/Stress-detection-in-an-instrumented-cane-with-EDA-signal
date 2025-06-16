# Stress-detection-in-an-instrumented-cane-with-EDA-signal
Trabajo de Fin de Grado del estudio de detección de estrés en un bastón instrumentado con sensor EDA.

Se ha realizado un estudio con el bastón instrumentado en 2 situaciones que se pueden dar, el usuario está ainmóvil apoyando parte de su peso en el bastón o cuando la persona camina con el bastón.

La situación de la persona en movimiento provoca que se introduzca artefactos en la señal EDA tomada lo que provoca que se corrompa la señal y pueda afectar de forma negativa a la detección de estrés.

La detección de estrés se puede realizar tomando unas características de la señal GSR tomada que pueden ser características estadísticas como la media, moda, mediana, etc o características propias de un pico como es el tiempo de subida del pico o la amplitud del pico. El cálculo de las características se realizan en ventanas que ocurren antes del evento de estrés y después del evento de estrés. Con esto se realiza 2 grupos de ventanas las que están sometidas al evento de estrés y las que no están sometidas al evento de estrés.

Con estos 2 grupos se calculan las características a las ventanas de un grupo y a las ventanas del otro grupo. Para saber si hay una diferencia significativa de una característica en ambos grupos se aplican pruebas estadísticas como es la prueba t de Student para muestras independientes y pareadas, test de Wilcoxon signed-rank o Mann-Whitney U.

Al aplicar los tests se puede saber que características son significativas a la detección de estrés en la situación de que el usuario del bastón se mueve o se queda quieto.

Además del bastón instrumentado se ha usado otro sensor más que es la Empatica EmbracePlus, que es un sensor comercial usado en investigaciones similares a la de este TFG.

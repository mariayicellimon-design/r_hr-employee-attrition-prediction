# HR Employee Attrition Prediction

## 📌 Descripción

Este proyecto analiza los factores asociados a la rotación de empleados (*employee attrition*) y desarrolla modelos de predicción utilizando **Regresión Lineal Múltiple** y **Regresión Logística Binaria** en R.

El objetivo es identificar variables relacionadas con la probabilidad de que un empleado abandone la organización y evaluar el desempeño de ambos enfoques mediante datos de entrenamiento y prueba.

---

## 🎯 Objetivo

Desarrollar y comparar modelos estadísticos para analizar y predecir la rotación de empleados, identificando los principales factores asociados al abandono y evaluando la capacidad predictiva de los modelos.

---

## 📊 Dataset

El proyecto utiliza el dataset **IBM HR Analytics Employee Attrition & Performance**, disponible en Kaggle:

[Kaggle - IBM HR Analytics Employee Attrition & Performance](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)

El dataset contiene información de **1,470 empleados** y **35 variables** relacionadas con características demográficas, laborales y salariales.

### Variable objetivo

**Attrition**

- `Yes` → El empleado abandonó la organización.
- `No` → El empleado permaneció en la organización.

Para el modelado se creó una variable binaria:

- `1` → Abandono
- `0` → Permanencia

La variable presenta un desbalance entre clases:

- No: 83.88%
- Yes: 16.12%

---

## 🔎 Variables utilizadas

Las variables seleccionadas para los modelos fueron:

| Variable | Descripción |
|---|---|
| `YearsAtCompany` | Años que el empleado lleva trabajando en la empresa. |
| `YearsSinceLastPromotion` | Años transcurridos desde la última promoción. |
| `PerformanceRating` | Evaluación del desempeño del empleado. |
| `OverTime` | Indica si el empleado realiza horas extra. |
| `JobSatisfaction` | Nivel de satisfacción con el trabajo. |
| `Age` | Edad del empleado. |
| `MonthlyIncome` | Ingreso mensual del empleado. |
| `BusinessTravel` | Frecuencia con la que el empleado realiza viajes de trabajo. |

---

## 🧹 Preparación de los datos

Antes del modelado se realizaron las siguientes actividades:

- Exploración de la estructura del dataset.
- Análisis descriptivo de las variables.
- Verificación de valores faltantes.
- Verificación de registros duplicados.
- Transformación de la variable `Attrition` a una variable binaria.
- Conversión de variables categóricas relevantes a factores.
- Exploración gráfica mediante diagramas de caja.
- División de los datos en conjuntos de entrenamiento y prueba.

Se utilizó una división de:

- **75% → Train**
- **25% → Test**

La división se realizó utilizando una semilla fija (`set.seed(42)`) para garantizar reproducibilidad.

---

# 🤖 Modelos

## 1. Regresión Lineal Múltiple

Se entrenó un modelo de regresión lineal utilizando las mismas variables predictoras:

```r
modelo_lineal <- lm(
  Attrition_bin ~ YearsAtCompany +
    YearsSinceLastPromotion +
    PerformanceRating +
    OverTime +
    JobSatisfaction +
    Age +
    MonthlyIncome +
    BusinessTravel,
  data = train
)

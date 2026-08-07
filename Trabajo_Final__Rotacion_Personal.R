# ===========================================================
# PROYECTO FINAL
# Predicción de Rotación de Empleados
# Comparación entre Regresión Lineal y Regresión Logística
# Dataset: IBM HR Analytics Employee Attrition
# https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset
# Nombre: María Yicel Limón Bartelemy
# ===========================================================

# -----------------------------------------------------------
# PASO 0: Cargar librerías
# -----------------------------------------------------------

library(caret)
library(dplyr)
library(yardstick)
library(car)

# -----------------------------------------------------------
# PASO 1: Cargar datos
# -----------------------------------------------------------

RHBase <- read.csv(
  "C:/Users/YICEL/Desktop/Diplomado ML y Ciencia de datos/Modelos de Predicción/HR-Employee-Attrition.csv",
  stringsAsFactors = FALSE
)

# -----------------------------------------------------------
# PASO 2: Exploración inicial
# -----------------------------------------------------------

glimpse(RHBase)

summary(RHBase)

head(RHBase)

# Distribución de la variable objetivo

table(RHBase$Attrition)

prop.table(table(RHBase$Attrition))*100

# -----------------------------------------------------------
# PASO 3: Limpieza y transformación
# -----------------------------------------------------------

# Valores faltantes

colSums(is.na(RHBase))

# Registros duplicados

sum(duplicated(RHBase))

# Crear variable binaria

RHBase$Attrition_bin <- ifelse(RHBase$Attrition == "Yes", 1, 0)

# Convertir variables categóricas

RHBase <- RHBase %>%
  mutate(
    Attrition = factor(Attrition),
    OverTime = factor(OverTime),
    BusinessTravel = factor(BusinessTravel)
  )

# -----------------------------------------------------------
# PASO 4: Exploración gráfica
# -----------------------------------------------------------

boxplot(RHBase$Age)

boxplot(RHBase$MonthlyIncome)

boxplot(RHBase$YearsAtCompany)

# -----------------------------------------------------------
# PASO 5: División entrenamiento / prueba
# -----------------------------------------------------------

set.seed(42)

indice_train <- createDataPartition(RHBase$Attrition_bin, p = 0.75,
  list = FALSE)

train <- RHBase[indice_train, ]

test <- RHBase[-indice_train, ]

# -----------------------------------------------------------
# PASO 6: Entrenar modelo de regresión lineal
# -----------------------------------------------------------

modelo_lineal <- lm(Attrition_bin ~   YearsAtCompany + YearsSinceLastPromotion +
    PerformanceRating + OverTime + JobSatisfaction +  Age +   MonthlyIncome +
    BusinessTravel, data = train)

summary(modelo_lineal)

# -----------------------------------------------------------
# PASO 7: Evaluar regresión lineal
# -----------------------------------------------------------

pred_train <- predict(modelo_lineal,train)

pred_test <- predict(modelo_lineal,test)

# Métricas Train

metricas_train <- tibble( real=train$Attrition_bin,  pred=pred_train) %>%
  metrics(truth=real, estimate=pred )

print(metricas_train)


# Métricas Test

metricas_test <- tibble(real=test$Attrition_bin, pred=pred_test) %>%
  metrics(truth=real,  estimate=pred)

print(metricas_test)

# Comparación Train/Test

resumen_lineal <- tibble( Conjunto=c("Train","Test"),
  MAE=c(metricas_train$.estimate[metricas_train$.metric=="mae"],
    metricas_test$.estimate[metricas_test$.metric=="mae"]),
  RMSE=c(metricas_train$.estimate[metricas_train$.metric=="rmse"],
    metricas_test$.estimate[metricas_test$.metric=="rmse"]),
  R2=c(metricas_train$.estimate[metricas_train$.metric=="rsq"],
    metricas_test$.estimate[metricas_test$.metric=="rsq"]))

print(resumen_lineal)

# Gráfico de Residuos

plot(modelo_lineal,which=1)

# Multicolinealidad

vif(modelo_lineal)

# -----------------------------------------------------------
# PASO 8: Entrenar modelo de regresión logística
# -----------------------------------------------------------

modelo_logistico <- glm(Attrition_bin ~ YearsAtCompany + YearsSinceLastPromotion +
    
    PerformanceRating +  OverTime + JobSatisfaction + Age + MonthlyIncome +
    
    BusinessTravel, data = train,  family = binomial)

summary(modelo_logistico)

# -----------------------------------------------------------
# PASO 9: Odds Ratios
# -----------------------------------------------------------

odds_ratios <- exp(coef(modelo_logistico))

print(odds_ratios)

odds_ratios_ic <- exp(cbind(OR = coef(modelo_logistico),
    
    confint(modelo_logistico)))

print(odds_ratios_ic)

# -----------------------------------------------------------
# PASO 10: Predicciones
# -----------------------------------------------------------

prob_logistica <- predict(modelo_logistico, newdata = test,
  
  type = "response")

head(prob_logistica)

# -----------------------------------------------------------
# PASO 11: Evaluación con umbral = 0.50
# -----------------------------------------------------------

umbral <- 0.50

pred_logistica <- ifelse(prob_logistica >= umbral, 1, 0)

matriz_confusion <- confusionMatrix(
  
  data = factor(pred_logistica, levels = c(0,1)),
  
  reference = factor(test$Attrition_bin, levels = c(0,1)),
  
  positive = "1")

print(matriz_confusion)

# -----------------------------------------------------------
# PASO 12: Evaluación con umbral = 0.30
# -----------------------------------------------------------

umbral_03 <- 0.30

pred_logistica_03 <- ifelse(prob_logistica >= umbral_03, 1, 0)

matriz_confusion_03 <- confusionMatrix(
  
  data = factor(pred_logistica_03, levels = c(0,1)),
  
  reference = factor(test$Attrition_bin, levels = c(0,1)),
  
  positive = "1")

print(matriz_confusion_03)

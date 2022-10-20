# Data-Science-R_Breast-Cancer-Study

This project was part of the Data Science R course in MsBAN program at Hult International Business School. The project aimed to explore breast cancer data,  create a logistic regression model, use testing data to test the model, and evaluate it using a confusion matrix. 

## Business Insight

Each variable has a significant impact on determining the odds of an individual having malignant cancer (success outcome) — i.e., Cl.thickness, Cell shape, Marg.adhesion,Bare.nuclei, and Bl.cromatin. Specifically, they have the following interpretation of their coefficients:

1. Cl.thickness: For every additional unit of Cl thickness, the odds of an individual having a malignant cancer (“business success”) increases by 86.50%.
2. Cell.shape: For every additional unit of Cell shape, the odds of an individual having a malignant cancer (“business success”) increases by 53.11%.
3. Marg.adhesion: For every additional unit of Marg. adhesion, the odds of an individual having a malignant cancer (“business success”) increases by 33.54%.
4. Bare.nuclei: For every additional unit of Bare.nuclei, the odds of an individual having a malignant cancer (“business success”) increases by 69.30%.
5. Bl.cromatin: For every additional unit of Bl.cromatin, the odds of an individual having a malignant cancer (“business success”) increases by 70.95%

On the other hand, the attributes of Mitoses, Normal.nucleoli, and Cell.size have no significant impact on the outcome. Even though that a great number of benign cases were mostly seen in the range of 1-2 for the Normal.nucleoli and Cell.size variables, the distribution of the malignant cases might have contributed to the lack of their impact on determining the type of cancer.

Overall, the predictive model has an Accuracy of around 96% . It has a high rate of correctly predicting the presence of a malignant cancer (true positive) or a benign cancer (true negative). More so the area under the curve is almost a 100%, reflecting the ability of the model to correctly distringuish between the positive (malignant) and negative (benign) class of cancer observations. That said, it can be deduced that the odds of having malignant cancer is significantly influenced by each and/or the combination of the following variables: Cl.thickness, Cell.shape, Marg.adhesion, Bare.nuclei, and Bl.cromatin.

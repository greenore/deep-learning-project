## Screencast Script

In this project, we developed deep learning networks for predicting the genres of movies based on their posters. We approached the task of genre prediction as a multi-label problem with 19 categories as used by The Movie Database (TMDb).

[show genre labels]

We scraped 69,000 .jpeg movie posters from TMDb in a resolution of 154 by 231 pixels, which were then resized and converted into RGB channel values using the Python Imaging Library. We used 30,000 posters for training, 19,000 for validation and 20,000 for testing.

[show posters]
[ 154 x 231 --> resize --> 154 x 154 --> convert to array --> 154 x 154 x 3 ]

First, we trained a small convolutional neural network (CNN) from scratch using Keras with TensorFlow backend on a GPU cloud-computing instance on AWS (Amazon Web Services). The architecture of our CNN is as shown.

[show diagram of architecture]

We used the ‘Adam’ optimizer with a binary cross-entropy loss. The activation function was ReLU (rectified linear unit) for the hidden layers, and sigmoid for the output layer. We set the learning rate to be 0.1, and reduced it by a factor of 0.2 when validation loss plateaued for 1 epoch, until a minimum of 0.001. Batch size was tuned to 500 and number of epochs to 10 with early stopping (when validation loss plateaus for X number of epochs).

We also employed L2 regularization and dropout. Weights were initialized with the Glorot method. The images were centered beforehand and data augmentation was also utilized.

[show diagram of fine-tuned network]

Next, we fine-tuned an existing pre-trained network. We chose the Inception-v3 network created by Google using data from the ImageNet Challenge in 2012. (?We added 2 dense layers on top of this network) We kept the bottom ___ layers frozen, and re-trained the remaining ___ layers on top for __ epochs. We used stochastic gradient descent (SGD) with momentum of 0.9 as the optimization method and a low learning rate of 0.0001.

These are the loss curves over the training process for the two networks. We see that __.

[show loss function]

To supplement the deep learning models, we also trained “traditional” machine learning models using movie metadata obtained from both TMDb and IMDb.

[show list of features]

Finally, we combined the genre predictions from the CNN trained on movie posters and random forest trained on movie metadata in a logistic regression model.
We evaluated our models using test accuracy, precision, recall and F1-score. As a benchmark, we created a baseline model, which randomly flags a genre at a probability of around 10%, which is the overall proportion of true flags across all 19 genres.

[show graph of final results]

Our best model was the ___ which achieved a F1 score of ___, which was higher than baseline.

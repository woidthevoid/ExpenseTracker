const express = require('express');
const corst = require('cors');
const mongoose = require('mongoose');
const body = require('body-parser');
require('dotenv').config();

const uri = process.env.MONGO_URI;

const app = express();
const port = 5001;

app.use(corst());
app.use(body.json());

mongoose.connect(uri, {
  })
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.error(err));

  const expenseSchema = new mongoose.Schema({
    title: String,
    amount: Number,
    category: String,
    date: { type: Date, default: Date.now },
  });

const Expense = mongoose.model("Expense", expenseSchema);

//Routes
app.get('/expenses', async (req, res) => {
  try {
    const expenses = await Expense.find();
    res.json(expenses);
  } catch (error) {
    res.status(500).json({ message: "Error fetching expenses", error });
  }
});

app.post('/expenses', async (req, res) => {
    const expense = new Expense(req.body);
    await expense.save();
    res.json(expense);
});

app.delete('/expenses/:id', async (req, res) => {
  const result = await Expense.deleteOne({id: req.params.id});
  res.json(result);
})

app.listen(port, () => console.log('Server is running on port ' + port));
const express = require('express');
const corst = require('cors');
const mongoose = require('mongoose');
const body = require('body-parser');
require('dotenv').config();

const uri = process.env.MONGO_URI;

const app = express();
const port = process.env.PORT || 5001;

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

app.post("/expenses", async (req, res) => {
  try {
    const { title, amount, category } = req.body;
    const expense = new Expense({ title, amount, category });
    await expense.save();
    res.status(201).json(expense);
  } catch (e) {
    res.status(500).json({ message: "Error creating expense", e });
  }
});

app.delete('/expenses/:id', async (req, res) => {
  const result = await Expense.deleteOne({_id: req.params.id});
  if(result.deletedCount === 0) {
    return res.status(404).json({message: "Expense not found"});
  }
  res.json({message: "Expense deleted"});
})

app.listen(port, () => console.log('Server is running on port ' + port));
const express = require('express');
const corst = require('cors');
const mongoose = require('mongoose');
const body = require('body-parser');

const uri = "mongodb+srv://admin:XOg380Rk88i3oY0W@expensesapp.x7mpm.mongodb.net/?retryWrites=true&w=majority&appName=ExpensesApp";;

const app = express();
const port = 5001;

app.use(corst());
app.use(body.json());

mongoose.connect(uri, {
  })
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.error(err));

  const expenseSchema = new mongoose.Schema({
    id: Number,
    title: String,
    amount: Number,
    category: String,
    date: { type: Date, default: Date.now },
  });

const Expense = mongoose.model("Expense", expenseSchema);

//Routes
app.get('/expenses', async (req, res) => {
    const expenses = await Expense.find();
    res.json(expenses);
});

app.post('/expenses', async (req, res) => {
    const expense = new Expense(req.body);
    await expense.save();
    res.json(expense);
});

app.listen(port, () => console.log('Server is running on port ' + port));
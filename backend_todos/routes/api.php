<?php

use App\Http\Controllers\ItemListController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get("/get", [ItemListController::class, "getTodos"]);
Route::get("/get/today", [ItemListController::class, "getTodayTodos"]);
Route::post("/add", [ItemListController::class, "createTodos"]);
Route::put("/add", [ItemListController::class, "editTodos"]);
Route::post("/delete", [ItemListController::class, "deleteTodos"]);



<?php

namespace App\Http\Controllers;

use App\Models\ItemList;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

class ItemListController extends Controller
{
    // Ambil semua todos, bisa di-filter pakai isPriority & isCompleted
    public function getTodos(Request $request)
    {
        $query = ItemList::query();

        if ($request->has('isPriority')) {
            $query->where('isPriority', $request->boolean('isPriority'));
        }

        if ($request->has('isCompleted')) {
            $query->where('isCompleted', $request->boolean('isCompleted'));
        }
        $query->orderBy('isCompleted', 'asc') // false (belum selesai) → true (selesai)
            ->orderBy('isPriority', 'desc') // true (prioritas) → false (biasa)
            ->orderBy('due_date', 'asc');

        return response()->json($query->get());
    }

    public function getTodayTodos(Request $request)
    {
        $today = Carbon::today();

        $todos = ItemList::whereDate('due_date', $today)->get();

        return response()->json($todos);
    }

    // Ambil todos berdasarkan tanggal dari parameter (format: YYYY-MM-DD)
    public function getTodosByTanggal(Request $request)
    {
        $request->validate([
            'date' => 'required|date'
        ]);

        $todos = ItemList::whereDate('due_date', $request->date)->get();

        return response()->json($todos);
    }

    // Buat todo baru
    public function createTodos(Request $request)
    {
        $data = $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'due_date' => 'required|date',
            'category' => 'nullable|string',
            'isCompleted' => 'boolean',
            'isPriority' => 'boolean',
        ]);

        $todo = ItemList::create($data);

        return response()->json($todo, 201);
    }

    // Edit todo berdasarkan id
    public function editTodos(Request $request)
    {
        $request->validate([
            'id' => 'required|exists:item_lists,id',
        ]);

        $todo = ItemList::findOrFail($request->id);

        $todo->update($request->only([
            'title',
            'description',
            'due_date',
            'category',
            'isCompleted',
            'isPriority'
        ]));

        return response()->json($todo);
    }

    // Hapus todo berdasarkan id
    public function deleteTodos(Request $request)
    {
        $request->validate([
            'id' => 'required|exists:item_lists,id',
        ]);

        $todo = ItemList::findOrFail($request->id);
        $todo->delete();

        return response()->json(['message' => 'Todo deleted successfully.']);
    }
}

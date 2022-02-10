<?php

namespace App\Http\Controllers\Task;

use App\Http\Controllers\Controller;
use App\Models\Task;
use Illuminate\Http\Request;



class TaskController extends Controller
{
    public function store(Request $request)
    {
    
    $validateData = $request->validate([
        'user_id' => 'required',
        'title' => 'required',
        'body' => 'required',
        'status' => 'required'
    ]);
    
    $data = new Task();
    $data->user_id = $request->user_id;
    $data->title = $request->title;
    $data->body = $request->body;
    $data->status = $request->status;
    $data->save();

    return response()->json($data, 201);

    }

    public function destroy(Request $request){
        $task = Task::where('id', '=', $request->id)->first();
        if ($task->id == $request->id){
            $task->delete();

            return response()->json([
                'success' => 'Your Task is deleted successfully'
            ], 200);
        }

        return response()->json([
            'error' => 'Task does not belong to you'
        ], 404);
    }

    public function getTask($id)
    {
        $data = Task::find($id);
        if ($data) {
            return response()->json($data, 200);
        }
        return response()->json([
            'error' => 'Id tidak tersedia'
        ], 404);
    }

    public function getTask1()
    {
        $data = Task::All();
        
            return response()->json($data, 200);
        
    }

}
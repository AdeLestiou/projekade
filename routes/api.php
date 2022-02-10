<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\Task\TaskController;
use Illuminate\Auth\Events\Login;
use Illuminate\Support\Facades\Auth;

use function GuzzleHttp\Promise\task;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});


Route::post('register', [AuthController::class, 'register']);
Route::post('login', [AuthController::class, 'login']);
Route::get('logout', [AuthController::class, 'logout']);

Route::group(['middleware' => 'auth:api'], function(){

Route::post('tasks', [TaskController::class, 'store']);
Route::delete('tasks/{id}', [TaskController::class, 'destroy']);
Route::get('/tasks/{id}', [TaskController::class, 'getTask']);
Route::get('/tasks', [TaskController::class, 'getTask1']);
});

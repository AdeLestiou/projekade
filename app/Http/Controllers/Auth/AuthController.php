<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;


class AuthController extends Controller
{
    public function register(Request $req){
        $validateData = $req->validate([
            'name' => 'required|max:25',
            'email' => 'email|required|unique:users',
            'password' => 'required|confirmed',
        ]);

        //create user
        $user = new User([
            'name' => $req->name,
            'email' => $req->email,
            'password' => bcrypt($req->password)
        ]);

        $user->save();
        return response()->json([
        'user' => $user,
        'succes' => true ], 201);
    }
    //end of register

    public function login(Request $request){
        $validateData = $request->validate([
            'email' => 'email|required',
            'password' => 'required'
        ]);

        $login_detail = request(['email', 'password']);


        if (!Auth::attempt($login_detail)){
            return response()->json(['error' => 'login failed!']);
        }

        $user = $request->user();

        $tokenResult = $user -> createToken('AccessToken');
        $token = $tokenResult ->token;
        $token->save();

        return response()->json([
            'access_token' => 'Bearer' .$tokenResult->accessToken,
            'token_id' => $token->id,
            'user_id' => $user->name,
            'name' => $user->name,
            'email' => $user->email
        ], 200);
    }
}

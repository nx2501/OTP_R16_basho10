%%
%% %CopyrightBegin%
%% 
%% Copyright Ericsson AB 2008-2009. All Rights Reserved.
%% 
%% The contents of this file are subject to the Erlang Public License,
%% Version 1.1, (the "License"); you may not use this file except in
%% compliance with the License. You should have received a copy of the
%% Erlang Public License along with this software. If not, it can be
%% retrieved online at http://www.erlang.org/.
%% 
%% Software distributed under the License is distributed on an "AS IS"
%% basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
%% the License for the specific language governing rights and limitations
%% under the License.
%% 
%% %CopyrightEnd%
%%
-module(archive_script_main).
-behaviour(escript).

-export([main/1]).

-define(DUMMY, archive_script_dummy).
-define(DICT, archive_script_dict).

main(MainArgs) ->
    %% Some printouts
    io:format("main:~p\n",[MainArgs]),
    ErlArgs = init:get_arguments(),
    io:format("dict:~p\n",[[E || E <- ErlArgs, element(1, E) =:= ?DICT]]),
    io:format("dummy:~p\n",[[E || E <- ErlArgs, element(1, E) =:= ?DUMMY]]),

    %% Start the applications
    {error, {not_started, ?DICT}} = application:start(?DUMMY),
    ok = application:start(?DICT),
    ok = application:start(?DUMMY),
    
    %% Access dict priv dir
    PrivDir = code:priv_dir(?DICT),
    PrivFile = filename:join([PrivDir, "archive_script_dict.txt"]),
    case erl_prim_loader:get_file(PrivFile) of
	{ok, Bin, _FullPath} ->
	    io:format("priv:~p\n", [{ok, Bin}]);
	error ->
	    io:format("priv:~p\n", [{error, PrivFile}])
    end,
    
    %% Use the dict app
    Tab = archive_script_main_tab,
    Key = foo,
    Val = bar,
    {ok, _Pid} = ?DICT:new(Tab),
    error = ?DICT:find(Tab, Key),
    ok = ?DICT:store(Tab, Key, Val),
    {ok, Val} = ?DICT:find(Tab, Key),
    ok = ?DICT:erase(Tab, Key),
    error = ?DICT:find(Tab, Key),
    ok = ?DICT:erase(Tab),
    ok.


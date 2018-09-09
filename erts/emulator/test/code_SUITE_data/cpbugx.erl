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

-module(cpbugx).

-export([before/0,before2/0,before3/0]).

before() ->
    1 + lethal().

lethal() ->
    4711.

before2() ->
    {status,lethal2(self())}.

lethal2(Pid) ->
    try
	is_process_alive(Pid)
    catch
	_ ->
	    error
    end.

before3() ->
    atom_to_list(lethal3(self())).

lethal3(Pid) ->
    Pid ! garbage.

function xdot = toggleODE(t,x,params)

xdot = [params.alf./(1 + x(2).^4) - params.gam*x(1);
        params.bet./(1 + x(1).^4) - params.gam*x(2)];
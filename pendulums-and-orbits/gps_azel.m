%function [Az,El,rho] = gps_azel(theta_e, phi_e, phi_s, hemisphere)

% Computes look angles from observer lat/lon to defined GPS satellite at 
% given time of applicability.
%
% Inputs: 
%   theta_e -       Observer latitude (eg. 39.0 N)
%   phi_e -         Observer longitude (eg. 110.0 W)
%   phi_s -         satellite longitude (eg. 119 for DirectTV 7S) 
%   hemisphere -    1 = northern hemisphere, 2 = southern hemisphere
%
% Ouputs:
%   az -        Satellite azimuth from observer position
%   el -        Satellite elevation from observer position
%   rho -       range to satellite from observer position
%
%
%   Example of orbital parameters for typical GPS Satellite
%
%   ******** Week 801 almanac for PRN-01 ******** 
%   ID: 01
%   Health: 000
%   Eccentricity: 0.3765106201E-002
%   Time of Applicability(s): 503808.0000
%   Orbital Inclination(rad): 0.9617064849
%   Rate of Right Ascen(r/s): -0.7817468486E-008 
%   SQRT(A) (m 1/2): 5153.614258
%   Right Ascen at Week(rad): 0.7017688714E+000 
%   Argument of Perigee(rad): 0.434909394   
%   Mean Anom(rad): 0.4480223834E+000
%   Af0(s): -0.1049041748E-004
%   Af1(s/s):0.0000000000E+000
%   week:801
%
%
% Author: drohm - kickview
%-------------------------------------------------------------------------

%-Constants
R = 6378137;                % equitorial radius of the earth (m) - WGS84

%-Example Defined parameters
a = 5153.614258^2;          % semi-major axis in meters
hemisphere = 1;
theta_e = 39.0;             % earth station latitude
phi_e = 77.0;               % earth station longitude  
phi_s = 119;                % satellite longitude
phi_se = phi_s - phi_e;
e = 0.3765106201e-2;        % eccentricity
mu = 3.98605*10^14;         % standard gravitational parameter
n = sqrt(mu/a^3);           % mean motion (average angular rate)
t0 = 2*pi/mu;               % time of paragee (orbital period)

%-Compute satellite azimuth/elevation from specified earth station using
%-Richharia's eqs (Satellite Communication Systems, 2nd ed., M. Richharia) 
%-Step1: Determine mean anomaly M at time t
M0 = 0.4480223834;
t = 500000.000 - 503808.0000;
M = M0 + n*(t-t0);

%-Compute E from knowledge of M and e
% M = E - esinE
% Starting E
E = 0.1;
% Start iteration
for i = 1:5 
    E = (M+e*sin(E) - e*cos(E))/(1-e*cos(E));   
end 

%-Compute position of satellite in orbital plane
x0 = a*(cosd(E) - e);
y0 = a*(1-e^2)^(1/2)*sin(E);
r = sqrt(x0^2 + y0^2);

%-Step2: Transform to geocentric equatorial coordinate system
s_omega = 0.434909394;          % argument of perigee
l_omega = 0.7017688714 ;        % right ascension
i = 0.9617064849;               % inclination (0-90 degrees), if negative 
                                % add 180 to right ascension

Px = cos(s_omega)*cos(l_omega) - sin(s_omega)*sin(l_omega)*cos(i);
Py = cos(s_omega)*sin(l_omega) + sin(s_omega)*cos(l_omega)*cos(i);
Pz = sin(s_omega)*sin(i);
Qx = -1*sin(s_omega)*cos(l_omega) - cos(s_omega)*sin(l_omega)*cos(i);
Qy = -1*sin(s_omega)*sin(l_omega) + cos(s_omega)*cos(l_omega)*cos(i);
Qz = cos(s_omega)*sin(i);

%-Compute satellite position in the geocentric coordinate system
x = Px*x0 + Qx*y0;
y = Py*x0 + Qy*y0;
z = Pz*x0 + Qz*y0;

%-Compute satellite azimuth and elevation from spcified earth station
alpha = atan(y/x);                          % right ascension
delta = atan(z/(sqrt(x^2 + y^2)));          % declination(or inclination)
eta_s = asind( sind(delta)*sind(theta_e) ...
    + cosd(delta)*cosd(theta_e)*cosd(phi_se) );
El = atand( (sind(eta_s) - R/r)/cosd(eta_s) );
Az = atand( sind(phi_se)/(cosd(theta_e)*tand(delta) ...
    - sind(theta_e)*cosd(phi_se)) );

%-Make corrections for hemisphere and earth azimuth quadrant
if hemisphere == 1          % northern hemisphere
    if phi_se < 0
        Az = 180 + Az;
    elseif phi_se > 0
        Az = 180 - Az;
    else
        Az = Az;
    end   
elseif hemisphere == 2      % southern hemisphere
    if phi_se < 0
        Az = 360 - Az;
    elseif phi_se > 0
        Az = 180 - Az;
    else
        Az = Az;
    end
end

%-Compute range from observer to satellite
rho = sqrt( r^2 - R^2*cosd(El)^2 ) - R*sind(El);

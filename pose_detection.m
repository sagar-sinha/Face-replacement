function [repl_face, repl_ctrl_pts] = pose_detection(off, smiling, dir, race,  Faces, ControlPoints  )
%POSE_DETECTION Summary of this function goes here
%   Detailed explanation goes here
    if off == true
        repl_face = Faces{1,2};
        repl_ctrl_pts = ControlPoints{1,2};
        return;
    end

    if dir == 0
        if smiling == 1
            repl_face = Faces{1,4};
            repl_ctrl_pts = ControlPoints{1,4};
        else
            repl_face = Faces{1,1};
            repl_ctrl_pts = ControlPoints{1,1};
        end
    elseif dir == 1
        if smiling == 1
            repl_face = Faces{1,5};
            repl_ctrl_pts = ControlPoints{1,5};
        else
            repl_face = Faces{1,2};
            repl_ctrl_pts = ControlPoints{1,2};
        end
    elseif dir == 2
        if smiling == 1
            repl_face = Faces{1,6};
            repl_ctrl_pts = ControlPoints{1,6};
        else
            repl_face = Faces{1,3};
            repl_ctrl_pts = ControlPoints{1,3};
        end
    end

end


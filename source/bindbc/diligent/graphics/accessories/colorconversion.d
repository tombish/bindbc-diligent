/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  Copyright 2015-2019 Egor Yusov
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence), 
 *  contract, or otherwise, unless required by applicable law (such as deliberate 
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental, 
 *  or consequential damages of any character arising as a result of this License or 
 *  out of the use or inability to use the software (including but not limited to damages 
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and 
 *  all other commercial damages or losses), even if such Contributor has been advised 
 *  of the possibility of such damages.
 */

module bindbc.diligent.graphics.accessories.colorconversion;

import std.math;

// https://en.wikipedia.org/wiki/SRGB
float LinearToSRGB(float x)
{
    return x <= 0.0031308 ? x * 12.92f : 1.055f * pow(x, 1.0f / 2.4f) - 0.055f;
}

float SRGBToLinear(float x)
{
    return x <= 0.04045f ? x / 12.92f : pow((x + 0.055f) / 1.055f, 2.4f);
}

float LinearToSRGB(ubyte x);
float SRGBToLinear(ubyte x);

float FastLinearToSRGB(float x)
{
    return x < 0.0031308f ? 12.92f * x : 1.13005f * sqrt(fabs(x - 0.00228f)) - 0.13448f * x + 0.005719f;
}

float FastSRGBToLinear(float x)
{
    // http://chilliant.blogspot.com/2012/08/srgb-approximations-for-hlsl.html
    return x * (x * (x * 0.305306011f + 0.682171111f) + 0.012522878f);
}

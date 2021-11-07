/*
 *  Copyright 2021 Thomas Bishop
 *  Distributed under the Boost Software License, Version 1.0
 *  See accompanying file LICENSE or https://www.boost.org/LICENSE_1_0.txt
 */
 
/*
 *  Copyright 2019-2021 Diligent Graphics LLC
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT OF ANY PROPRIETARY RIGHTS.
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

module bindbc.diligent.graphics.metal.samplermtl;

/// \file
/// Definition of the Diligent::ISamplerMtl interface

import bindbc.diligent.graphics.sampler;

// {73F8C099-049B-4C81-AD19-C98963AC7FEB}
static const INTERFACE_ID IID_SamplerMtl =
    INTERFACE_ID(0x73f8c099, 0x49b, 0x4c81, [0xad, 0x19, 0xc9, 0x89, 0x63, 0xac, 0x7f, 0xeb]);

/// Exposes Metal-specific functionality of a sampler object.
struct ISamplerMtlMethods
{
    MTLSamplerState** GetMtlSampler(ISamplerMtl*);
}

struct ISamplerMtlVtbl { ISamplerMtlMethods SamplerMtl; }
struct ISamplerMtl { ISamplerMtlVtbl* pVtbl; }

MTLSamplerState** ISamplerMtl_GetMtlSampler(ISamplerMtl* sampler) {
    return sampler.pVtbl.SamplerMtl.GetMtlSampler(sampler);
}
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

module bindbc.diligent.graphics.tools.commonlyusedstates;

/// \file
/// Defines graphics engine utilities

import bindbc.diligent.graphics.graphicstypes;
import bindbc.diligent.graphics.depthstencilstate;
import bindbc.diligent.graphics.blendstate;
import bindbc.diligent.graphics.rasterizerstate;
import bindbc.diligent.graphics.sampler;

// Common depth-stencil states
static const DepthStencilStateDesc DSS_Default = {};

static const DepthStencilStateDesc DSS_DisableDepth = { DepthEnable: false, DepthWriteEnable: false };


// Common rasterizer states
static const RasterizerStateDesc RS_Default = {};

static const RasterizerStateDesc RS_SolidFillNoCull = { FillMode: FILL_MODE.FILL_MODE_SOLID, CullMode: CULL_MODE.CULL_MODE_NONE };

static const RasterizerStateDesc RS_WireFillNoCull = { FillMode: FILL_MODE.FILL_MODE_WIREFRAME, CullMode: CULL_MODE.CULL_MODE_NONE };

// Blend states
static const BlendStateDesc BS_Default = {};

static const BlendStateDesc BS_AlphaBlend = 
{
    AlphaToCoverageEnable: false,
    IndependentBlendEnable: false,
	RenderTargets:
    {
		BlendEnable: true,
        LogicOperationEnable: false,
        SrcBlend: BLEND_FACTOR.BLEND_FACTOR_SRC_ALPHA,
        DestBlend: BLEND_FACTOR.BLEND_FACTOR_INV_SRC_ALPHA,
		BlendOp: BLEND_OPERATION.BLEND_OPERATION_ADD,
        SrcBlendAlpha: BLEND_FACTOR.BLEND_FACTOR_SRC_ALPHA,
        DestBlendAlpha: BLEND_FACTOR.BLEND_FACTOR_INV_SRC_ALPHA,
		BlendOpAlpha: BLEND_OPERATION.BLEND_OPERATION_ADD
	}
};

// Common sampler states
static const SamplerDesc Sam_LinearClamp =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_LINEAR,
    MagFilter: FILTER_TYPE.FILTER_TYPE_LINEAR,
    MipFilter: FILTER_TYPE.FILTER_TYPE_LINEAR, 
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP
};

static const SamplerDesc Sam_PointClamp =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_POINT,
    MagFilter: FILTER_TYPE.FILTER_TYPE_POINT,
    MipFilter: FILTER_TYPE.FILTER_TYPE_POINT, 
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP
};

static const SamplerDesc Sam_LinearMirror =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_LINEAR,
    MagFilter: FILTER_TYPE.FILTER_TYPE_LINEAR,
    MipFilter: FILTER_TYPE.FILTER_TYPE_LINEAR, 
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_MIRROR,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_MIRROR,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_MIRROR
};

static const SamplerDesc Sam_PointWrap =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_POINT,
    MagFilter: FILTER_TYPE.FILTER_TYPE_POINT,
    MipFilter: FILTER_TYPE.FILTER_TYPE_POINT,
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP
};

static const SamplerDesc Sam_LinearWrap =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_LINEAR,
    MagFilter: FILTER_TYPE.FILTER_TYPE_LINEAR,
    MipFilter: FILTER_TYPE.FILTER_TYPE_LINEAR, 
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP
};

static const SamplerDesc Sam_ComparsionLinearClamp =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_COMPARISON_LINEAR,
    MagFilter: FILTER_TYPE.FILTER_TYPE_COMPARISON_LINEAR,
    MipFilter: FILTER_TYPE.FILTER_TYPE_COMPARISON_LINEAR, 
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    ComparisonFunc: COMPARISON_FUNCTION.COMPARISON_FUNC_LESS
};

static const SamplerDesc Sam_Aniso2xClamp =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MagFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MipFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC, 
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    MipLODBias: 0.f,
    MaxAnisotropy: 2
};

static const SamplerDesc Sam_Aniso4xClamp =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MagFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MipFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC, 
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    MipLODBias: 0.f,
    MaxAnisotropy: 4
};

static const SamplerDesc Sam_Aniso8xClamp =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MagFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MipFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC, 
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    MipLODBias: 0.f,
    MaxAnisotropy: 8
};

static const SamplerDesc Sam_Aniso16xClamp =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MagFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MipFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC, 
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_CLAMP,
    MipLODBias: 0.f,
    MaxAnisotropy: 16
};

static const SamplerDesc Sam_Aniso4xWrap =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MagFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MipFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC, 
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP,
    MipLODBias: 0.f,
    MaxAnisotropy: 4
};

static const SamplerDesc Sam_Aniso8xWrap =
{
    MinFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MagFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC,
    MipFilter: FILTER_TYPE.FILTER_TYPE_ANISOTROPIC, 
    AddressU: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP,
    AddressV: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP,
    AddressW: TEXTURE_ADDRESS.TEXTURE_ADDRESS_WRAP,
    MipLODBias: 0.f,
    MaxAnisotropy: 8
};
